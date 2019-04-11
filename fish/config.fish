set fish_greeting  ''

set -Ux EDITOR  vim

# History
set HISTSIZE  10000
set HISTFILESIZE  10000


# Homebrew
set -x PATH $PATH /usr/local/sbin

# Node
set -x PATH $PATH /usr/local/opt/node@10/bin

# Go
set -x GOPATH $HOME/go


# Aliases
alias lt "ls -lrt"

alias gcc "gcc-8"
alias g++ "g++-8"

