# dotfiles

[![make test](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml/badge.svg)](https://github.com/shinomineko/dotfiles/actions/workflows/make-test.yml)

### Installing

This will create a bunch of symlinks from this repo to your home directory

```console
make
```

### Run the tests

The tests run in a container

```console
make test
```

### Run the install script

Use it at your own risk

```console
curl -sSLO https://raw.githubusercontent.com/shinomineko/dotfiles/master/bin/install.sh
chmod +x install.sh
./install.sh
```
