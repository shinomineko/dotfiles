if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/env.fish

    if test -f ~/.extra.fish
        source ~/.extra.fish
    end
end
