#!/bin/bash

# fzf
rm -rf "$HOME/.fzf" "$HOME/.fzf.*"
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
FZF_OPTS=(--key-bindings --no-completion --no-update-rc --no-zsh --no-fish)
"$HOME/.fzf/install" "${FZF_OPTS[@]}"

# vim plug
curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
