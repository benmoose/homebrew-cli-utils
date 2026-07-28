#!/usr/bin/env zsh

set -o pipefail

function uuid {
    if ! which uuidgen &>/dev/null; then return 1; fi
    declare -r out=$(uuidgen | tr "[:upper:]" "[:lower:]")

    [[ "$1" != "-x" ]] && print -n "${out}" | pbcopy
	[[ "$1" != "-q" ]] && print "${out}"
}

function ,spinner {
    declare -r pid_arg="${1}" msg_arg="${2}" style_arg="${3:-$(\tput setaf 6)}" \
        CIVIS="$(\tput civis)" CNORM="$(\tput cnorm)" CR="$(\tput cr)" EL="$(\tput el)" NS="$(\tput sgr0)"
    declare -ar frames=("⠄", "⠆", "⠇", "⠋", "⠙", "⠸", "⠰", "⠠", "⠰", "⠸", "⠙", "⠋", "⠇", "⠆")
    declare -i i

    printf "${CIVIS}"  # hide cursor
    \trap 'printf "${CNORM}"' EXIT ERR
    while \kill -0 "${pid_arg}" 2>/dev/null; do
        printf "${CR}%s%s${NS}" "${style_arg}" "${frames[$((i % ${#frames[@]} + 1))]}" "${msg_arg}"
        ((i++))
        \sleep 0.045
    done
}
