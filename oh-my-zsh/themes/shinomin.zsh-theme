TIME="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
RPS1="%(?..%{$fg[red]%}%? <%{$reset_color%}) $TIME"

if [[ ${EUID} == 0 ]]; then
		PROMPT=' %{$fg[cyan]%}%c %{$fg_bold[white]%}% #%{$reset_color%} '
	else
		PROMPT=' %{$fg[cyan]%}%c %{$fg_bold[white]%}% $%{$reset_color%} '
	fi

