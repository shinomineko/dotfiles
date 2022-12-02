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

# return exit code 0 if command exists
has() {
	hash "$1" &>/dev/null
}


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

if has gpg-connect-agent; then
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi

GPG_TTY=$(tty)
export GPG_TTY

for file in $HOME/.{bash_prompt,aliases,functions,path,dockerfunc,extra,exports,fzf.bash}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file

# source kubectl bash completion
if has kubectl; then
	# shellcheck source=/dev/null
	source <(kubectl completion bash)
fi

# source helm bash completion
if has helm; then
	# shellcheck source=/dev/null
	source <(helm completion bash)
fi

if has direnv; then
	# shell source=/dev/null
	eval "$(direnv hook bash)"
fi
