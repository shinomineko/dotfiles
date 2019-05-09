set fish_greeting  ''

set -Ux EDITOR  vim

# History
set HISTSIZE  10000
set HISTFILESIZE  10000


# Homebrew
set -x PATH $PATH /usr/local/sbin

# Go
set -x GOPATH $HOME/go

# Rust
set -x PATH $PATH $HOME/.cargo/bin


# Aliases
alias lt "ls -lrt"

alias gcc "gcc-9"
alias g++ "g++-9"

