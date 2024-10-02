#!/usr/bin/env fish

set -Ux EDITOR vim
set -Ux VISUAL vim

fish_add_path "$HOME/.local/bin"
set -Ux GOPATH "$HOME/.go"
fish_add_path "$GOPATH/bin"
fish_add_path "/usr/local/go/bin"
fish_add_path "$HOME/.cargo/bin"

direnv hook fish | source
