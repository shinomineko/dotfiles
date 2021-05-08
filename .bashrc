#!/bin/bash

# if not running interactively, don't do anything
case "$-" in
	*i*) ;;
	*) return;;
esac

shell="$(command -v bash)"
export SHELL="$shell"

export PATH="${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

shopt -s checkwinsize
shopt -s nocaseglob
shopt -s cdspell
shopt -s autocd
shopt -s globstar


## ALIASES

if ls --color > /dev/null 2>&1; then
	colorflag="--color"
else
	colorflag="-G"
fi

# shellcheck disable=SC2139
alias ll="ls -lhF $colorflag"

# shellcheck disable=SC2139
alias la="ls -lhaF $colorflag"

# shellcheck disable=SC2139
alias lsd="ls -lhF $colorflag | grep --color=never '^d'"

# shellcheck disable=SC2139
alias ls="command ls $colorflag"

alias grep="grep --color=auto"

alias untar="tar xvf"

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

export HISTFILE="$HOME/.bash_history"
export HISTSIZE=5000000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoredups
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h"

shopt -s histappend


## PROMPT

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

PS1="\$(__prompt_hostname) \$(__prompt_pwd)\$(__prompt_git) \$(__prompt) "
export PS1


## COMPLETION

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		# shellcheck source=/dev/null
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		# shellcheck source=/dev/null
		. /etc/bash_completion
	elif [ -f /usr/local/etc/bash_completion ]; then
		# shellcheck source=/dev/null
		. /usr/local/etc/bash_completion
	fi
fi

if [[ -d /etc/bash_completion.d/ ]]; then
	for file in /etc/bash_completion.d/* ; do
		# shellcheck source=/dev/null
		source "$file"
	done
fi


## GPG

if hash gpg-connect-agent 2>/dev/null; then
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi

GPG_TTY=$(tty)
export GPG_TTY


## STUFF

for file in $HOME/.{functions,path,dockerfunc,extra,fzf.bash}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file
