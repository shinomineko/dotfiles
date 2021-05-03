#!/bin/bash
set -eo pipefail

ERRORS=()

for file in $(find . -not -path "*.git*" -type f | sort -u); do
	if file "$file" | grep -q shell; then
		{
			shellcheck "$file" && echo "[ok]: $file"
		} || {
			ERRORS+=("$file")
		}
	fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
	echo "no errors"
else
	echo "these files failed shellcheck: ${ERRORS[*]}"
fi
