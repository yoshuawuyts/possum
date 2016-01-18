#!/bin/sh

readonly alpine_version="3.3.1-x86"
readonly disk_file="hdd.img"
readonly disk_size=3
readonly alpine_url="http://wiki.alpinelinux.org/cgi-bin/dl.cgi/v3.3/releases/x86/alpine-$alpine_version.iso"
readonly cache_dir="/var/cache/possum"
readonly image_name="$cache_dir/alpine-$alpine_version.iso"

main () {
  create_cache
  download_alpine
  create_hdd
  install_cdrtools
  extract_kernel
  install_alpine
}

# create /var/cache
create_cache () {
  if [ ! -d "$cache_dir" ]; then
    printf "[ disk ] %s\n" "$cache_dir"
    sudo mkdir -p "$cache_dir"
    sudo chown "$(whoami)":staff "$cache_dir"
  fi
}

# download alpine linux
download_alpine () {
  if [ ! -f "$image_name" ]; then
    printf "[ download ] alpine %s\n" "$alpine_version"
    curl -sLo "$image_name" "$alpine_url"
  else
    printf "[ cache ] alpine %s\n" "$alpine_version"
  fi
}

# create hdd image (3GB)
create_hdd () {
  if [ ! -f "$disk_file" ]; then
    printf "[ disk ] %s %dG\n" "$disk_file" "$disk_size"
    dd if=/dev/zero of="$disk_file" bs=1G count="$disk_size" >& /dev/null
  else
    local_raw_size="$(stat --printf="%s" "$disk_file")"
    local_disk_size="$(dc -e "$local_raw_size 1024 / 1024 / 1024 / p")"
    printf "[ disk ] %s %dG\n" "$disk_file" "$local_disk_size"
  fi
}

# install cdrtools for isoinfo
install_cdrtools () {
  isoinfo -h 2> /dev/null
  if [ $? -ne 0 ]; then
    printf "[ download ] cdrtools\n"
    brew install cdrtools
  fi
}

# extract kernel and initramfs
extract_kernel () {
  isoinfo -i "$image_name" -J -x /boot/initramfs-grsec > initramfs-grsec
  isoinfo -i "$image_name" -J -x /boot/vmlinuz-grsec > vmlinuz-grsec
}

# mount filesystem
install_alpine () {
  KERNEL="vmlinuz-grsec"
  INITRD="initramfs-grsec"
  CMDLINE="modules=sd-mod,ext4,console quiet console=ttyS0 acpi=on"

  ACPI="-A"
  IMG_CD="3,ahci-cd,$image_name"
  IMG_HDD="4,virtio-blk,hdd.img"
  LPC_DEV="com1,stdio"
  MEM="1G"
  NET="2:0,virtio-net"
  PCI_DEV="0:0,hostbridge"
  PCI_DEV2="31,lpc"

  sudo xhyve "$ACPI" \
    -s "$IMG_CD" \
    -s "$IMG_HDD" \
    -l "$LPC_DEV" \
    -m "$MEM" \
    -s "$NET" -s "$PCI_DEV" -s "$PCI_DEV2" \
    -f kexec,"$KERNEL","$INITRD","$CMDLINE"
}

main
