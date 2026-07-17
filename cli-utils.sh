#!/usr/bin/env bash

# ,err prints an error message to stderr
function ,err {
	declare -r red=$(\tput setaf 1) ns=$(\tput sgr0)

	printf "${red}%s${ns}\n" "${*}" 1>&2
}

function ,spinner {
	declare -r pid="${1}" msg="${2}" style="${3:-$(\tput setaf 6)}" \
		civis=$(\tput civis); cnorm=$(\tput cnorm); cr=$(\tput cr); ns=$(\tput sgr0)
	readonly -a frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
	declare -i i

	print -n "${civis}" # Hide cursor
	\trap 'print -n "${cnorm}"' EXIT ERR

	while \kill -0 "${pid}" 2> /dev/null; do
		printf "${cr}${style}%s${ns} %s" "${frames[$((i % ${#frames[@]} + 1))]}" "${msg}"
		((i++))
		\sleep 0.045
	done
}

# uuid [-qx] generate a v4 UUID. Result is both copied to the clipboard and sent to stdout.
#	-x	Output to STDOUT only.
# 	-q	Quiet mode, copy to clipboard and supress stdout output.
function uuid {
	declare -r out=$(uuidgen | tr "[:upper:]" "[:lower:]")

	[[ "$1" != "-x" ]] && print -n "${out}" | pbcopy
	[[ "$1" != "-q" ]] && print "${out}"
}

# pwt [level] prints tree representation of working directory.
# 	level	depth to print, default is 1.
function pwt {
	if ! which tree &> /dev/null; then ,err "$0: tree not found in PATH"; return 127; fi

	tree -L "${1:-1}" --condense --gitignore .
}

# vj path validate JSON file.
function vj {
	if ! which jq &> /dev/null; then ,err "$0: jq not found in PATH"; return 127; fi

	jq empty "${@}"
}

# Get the name of the command that called this script
COMMAND=$(basename "$0")

# Execute the function matching that name, passing all arguments
if declare -f "${COMMAND}" > /dev/null; then
  "${COMMAND}" "$@"
else
  ,err "$0: function ${COMMAND} not found."
  exit 1
fi

