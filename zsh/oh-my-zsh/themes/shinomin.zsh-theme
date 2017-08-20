if [[ ${EUID} == 0 ]]; then
		PROMPT=' %{$fg[cyan]%}%c %{$fg_bold[white]%}% #%{$reset_color%} '
	else
		PROMPT=' %{$fg[cyan]%}%c %{$fg_bold[white]%}% $%{$reset_color%} '
	fi

