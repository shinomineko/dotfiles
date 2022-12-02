#!/usr/bin/env bash
set -eo pipefail

ERRORS=()

for file in $(find . -not -path "*.git*" -type f | sort -u); do
	if file "$file" | grep -q shell; then
		{
			shellcheck "$file" && echo "[OK]: $file"
		} || {
			ERRORS+=("$file")
		}
	fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
	echo "no errors"
else
	echo "[ERROR] these files failed shellcheck: ${ERRORS[*]}" >&2
	exit 1
fi
