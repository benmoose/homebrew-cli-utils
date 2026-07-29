#!/usr/bin/env zsh

set -o pipefail

alias uid="uuid"

function uuid {
	if ! which uuidgen &>/dev/null; then
		,err "$0: uuidgen not found"
		return 1
	fi

	declare -r out=$(uuidgen | tr -d '\n')

	if [[ "$1" != "-x" ]]; then
		printf "${out:l}" | pbcopy
	fi
	
	if [[ "$1" != "-q" ]]; then
		printf "${out:l}\n"
	fi
}
