# dotfiles

[![make test](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml/badge.svg)](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml)

### installing

```console
$ make
```

this will create a bunch of symlinks from this repo to your home directory

### uninstalling

```console
$ make clean
```

### run the tests

the tests run in a container

```console
$ make test
```

### run the bootstrap script

use it at your own risk

```console
$ curl -sSLO https://raw.githubusercontent.com/shinomineko/dotfiles/master/bootstrap.sh
$ chmod +x bootstrap.sh
$ ./bootstrap.sh
```
