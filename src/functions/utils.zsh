#!/usr/bin/env zsh

set -o pipefail

function ,err {
	# declare -r RED="$(\tput setaf 1)" NS="$(\tput sgr0)"

	printf "%s%s%s\n" "${RED}" "${*}" "${NS}" 1>&2
}

function ,spinner {
	declare -r pid_arg="${1}" msg_arg="${2}" style_arg="${3:-${CYAN}}"
	declare -ar frames=("⠄" "⠆" "⠇" "⠋" "⠙" "⠸" "⠰" "⠠" "⠰" "⠸" "⠙" "⠋" "⠇" "⠆")
	declare -i i

	printf "${CIVIS}"  # hide cursor
	trap 'printf "${CNORM}"' EXIT ERR

	while \kill -0 "${pid_arg}" 2>/dev/null; do
		printf "${CR}${style_arg}%s${NS} %s" "${frames[$((i % ${#frames[@]} + 1))]}" "${msg_arg}"
		((i++))
		sleep 0.045
	done
}
