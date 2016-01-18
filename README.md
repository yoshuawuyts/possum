# possum [![stability][0]][1]
[![build status][4]][5] [![test coverage][6]][7]

Recursive Linux for OSX and Linux. Based on [Alpine Linux][11].

## Features
- runs directly on OSX using [xhyve][8]
- runs tarball containers using [shocker][9] (tbi)
- manage system dependencies using [nix][10] (tbi)

## Architecture
```txt
 OS X            Host OS
--------------
 xhyve           OS X hypervisor
--------------
 Alpine          Client OS
--------------
 Nix             System package manager
--------------
 Shocker         Container manager
```

## See Also
- [pagetable/xhyve](http://www.pagetable.com/?p=831)
- [shocker][9]

## License
[MIT](https://tldrlegal.com/license/mit-license)

[0]: https://img.shields.io/badge/stability-experimental-orange.svg?style=flat-square
[1]: https://nodejs.org/api/documentation.html#documentation_stability_index
[4]: https://img.shields.io/travis/yoshuawuyts/possum/master.svg?style=flat-square
[5]: https://travis-ci.org/yoshuawuyts/possum
[6]: https://img.shields.io/codecov/c/github/yoshuawuyts/possum/master.svg?style=flat-square
[7]: https://codecov.io/github/yoshuawuyts/possum
[8]: https://github.com/mist64/xhyve
[9]: https://github.com/stamf/shocker
[10]: https://github.com/NixOS/nix
[11]: http://www.alpinelinux.org/
