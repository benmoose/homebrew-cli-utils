#!/usr/bin/env zsh

set -o pipefail

function uuid {
	if ! which uuidgen &>/dev/null; then return 1; fi
	declare -r out=$(uuidgen | tr "[:upper:]" "[:lower:]")

	[[ "$1" != "-x" ]] && print -n "${out}" | pbcopy
	[[ "$1" != "-q" ]] && print "${out}"
}
