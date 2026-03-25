set -e -U EDITOR
set -gx EDITOR hx
set -e -U VISUAL
set -gx VISUAL hx
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

fish_add_path "$HOME/.local/bin"

if command -q zoxide
    zoxide init fish | source
end
