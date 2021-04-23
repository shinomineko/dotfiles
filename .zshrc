#!/bin/zsh

## INIT

PATH=

prependpath() {
  case ":$PATH:" in
    *:"$1":*)
      ;;

    * )
      PATH="${1:+$1:}$PATH"
      ;;
  esac

  PATH=${PATH%%:}
}

prependpath "/sbin"
prependpath "/usr/sbin"
prependpath "/bin"
prependpath "/usr/bin"

prependpath "/usr/local/sbin"
prependpath "/usr/local/bin"

prependpath "/opt/bin"
prependpath "/opt/local/bin"

prependpath "$HOME/.local/bin"

unset prependpath

export PATH


## ALIASES

alias exit="echo idiot"

alias ls="command ls --color"
alias ll="ls -lh"
alias lll="ls -lha"

alias vi="vim"
alias k="kubectl"

alias bssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias bscp="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

if hash nvim 2>/dev/null; then
  alias vim="nvim"
fi

if hash podman 2>/dev/null && ! hash docker 2>/dev/null; then
  alias docker="podman"
fi


## EXPORT

export EDITOR="vim"
export VISUAL="vim"

export LS_COLORS="di=32:ln=1;31:so=37:pi=1;33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx
export CLICOLOR=1

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"


## HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history


## PROMPT

autoload -Uz colors && colors
setopt promptsubst

__prompt() {
  if [ "$(id -u)" -eq "0" ]; then
    echo \#
  else
    echo \$
  fi
}

__prompt_hostname() {
  typeset short_hostname=$(hostname)
  printf "%s" "${short_hostname%%.*}"
}

__prompt_git() {
  _branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$_branch" ]; then
    echo " * $_branch"
  else
    echo ""
  fi
}

__prompt_pwd() {
    pwd | sed "
s|^$HOME|~|;                                    # $HOME -> ~
s|\([^[:punct:]]\)[^/]*/|\1/|g;                 # foo/bar/baz -> f/b/baz
s|^\(././\)././././.*/\(./[^/]*\)$|\1.../\2|g;  # 1/2/3/4/5/6/7/8/9/10 -> 1/.../9/10
"
}

export PROMPT='$(__prompt_hostname) $(__prompt_pwd)$(__prompt_git) $(__prompt) '


## COMPLETION

autoload -Uz compinit && compinit

autoload -Uz bashcompinit && bashcompinit

# change word-selection style to be like bash. this makes alt+backspace delete "bar" in "foo/bar" instead of the entire thing.
autoload -Uz select-word-style && select-word-style bash

zstyle ':completion:*' completer _expand_alias _complete _ignored


## PLUGINS

[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=13'

[[ -r "$HOME/.fzf.zsh"  ]] && source "$HOME/.fzf.zsh"


## GPG

if hash gpg-connect-agent 2>/dev/null; then
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

GPG_TTY=$(tty)
export GPG_TTY


# STUFF

for file in $HOME/.{extra,functions,dockerfunc}; do
  [[ -r "$file" ]] && source "$file"
done
unset file

