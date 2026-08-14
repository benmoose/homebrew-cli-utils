#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

builtin emulate -L zsh
set -u

local -r \
	name="${0:t}" \
	filepath="$(brew --prefix cli-utils)/bin/${0:t}"

update_line() {
	local \
		line="${1}" \
		file="${2}" \
		pat="${3}" \
		lines=""

	echo "Checking ${file:t}..."
	if [[ -f "${file}" ]]; then
		if [[ -n "${pat}"]]; then
			lines=$(\grep -nF "${pat}" "${file}")
		else
			lines=$(\grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	if [[ -n "${lines}" ]]; then
		echo "  line already exists in ${file:t}"
		sed 's/^/    → /' <<< "${lines}"
		return
	fi

	echo "Writing ${file:t}:"
	set -e
	[[ -f "${file}" ]] && echo >> "${file}"
	while read -r l; do
		echo "  ${l}"
		echo "${l}" >> "${file}";
	done < <(${line})
	set +e

	echo "Done"
}

initsrc() {
	cat << EOF
# benmoose/cli-utils
brew --prefix --installed ${name} &>/dev/null && source ${filepath}
EOF
}

install () {
	[[ "${SHELL}" =~ zsh$ ]] && dest=${ZDOTDIR:-~}/.zshrc || dest=${HOME:-~}/.bashrc
	
	if [[ ! -f "${dest}" || ! -w "${dest}" ]]; then
		echo "error: .zshrc is missing or unwritable"
		return 1
	fi

	update_line $(initsrc) "${dest}" "${filepath}"
}

if [[ -n "${1}" && "${1:l}" == "--zsh" ]]; then
	install
	return $?
fi

export -TU FPATH fpath

() {
	while (( ${#} )); do
		[[ -n "${fpath[(r)${1:a}]}" ]] || fpath+=("${1:a}")
		
		if [[ -z "${fpath[(r)${1:a}]}" ]]; then
			fpath+=("${1:a}")
		fi

		if [[ -d "${1:a}" ]]; then
			builtin autoload -Uz ${1:a}/*(:t)
			return $?
		fi
	shift; done;
	
	printf >&2 \
		"%s: functions missing, try reinstalling with \`brew reinstall %s\`\n" "${name}" "${name}"
	false
} ".(fn-dir)" "${*}" || false

if [[ "$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)" != "10" ]]; then
	declare -grx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
		MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) \
		BOLD=$(tput bold) DIM=$(tput dim) \
		CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
fi
