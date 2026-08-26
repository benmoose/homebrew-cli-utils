# uuid [-qx] - Print a v4 UUID
#	-q	Supress output to stdout.
#	-x	Do not copy UUID to the clipboard.

builtin emulate -L zsh
set -o pipefail
0="${${(M)0:#/*}:-$PWD/$0}"

if ! which uuidgen &>/dev/null; then
	_err "${0:t}: uuidgen not found"
	return 1
fi

local -r out=$(uuidgen | tr -d '\n')

if [[ "$1" != "-x" ]]; then
	printf "${out:l}" | pbcopy
fi

if [[ "$1" != "-q" ]]; then
	print "${out:l}"
fi
