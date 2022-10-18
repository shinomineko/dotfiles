#!/bin/bash

# if not running interactively, don't do anything
case "$-" in
	*i*) ;;
	*) return;;
esac

shopt -s checkwinsize
shopt -s nocaseglob
shopt -s cdspell
shopt -s autocd
shopt -s globstar
shopt -s histappend


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

# source kubectl bash completion
if hash kubectl 2>/dev/null; then
	# shellcheck source=/dev/null
	source <(kubectl completion bash)
fi

# source helm bash completion
if hash helm 2>/dev/null; then
	# shellcheck source=/dev/null
	source <(helm completion bash)
fi


for file in $HOME/.{bash_prompt,aliases,functions,path,dockerfunc,extra,exports,fzf.bash}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file


if hash direnv 2>/dev/null; then
	# shell source=/dev/null
	eval "$(direnv hook bash)"
fi
