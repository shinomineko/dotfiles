# dotfiles

[![make test](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml/badge.svg)](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml)

### installing

this will create a bunch of symlinks from this repo to your home directory

```console
$ make
```

### run the tests

the tests run in a container

```console
$ make test
```

### run the install script

use it at your own risk

```console
$ curl -sSLO https://raw.githubusercontent.com/shinomineko/dotfiles/master/bin/install.sh
$ chmod +x install.sh
$ ./install.sh
```
