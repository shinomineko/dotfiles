set -Ux EDITOR hx
set -Ux VISUAL hx
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

fish_add_path "$HOME/.local/bin"
set -gx GOPATH "$HOME/.go"
fish_add_path "$GOPATH/bin"
fish_add_path /usr/local/go/bin
fish_add_path "$HOME/.cargo/bin"

direnv hook fish | source
