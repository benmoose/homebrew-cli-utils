#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

set -u

echo "source: ${_:-}"

return 0

_is_zsh() {
	[ -n "${ZSH_VERSION-}" ]
}

_init_func () {
	export -U FPATH fpath

	[[ -z "${1}" ]] && return 1

	if [[ -z ${fpath[(r)"${1:a}"]} ]]; then
		fpath+=("${1:a}")
	fi

	if [[ ! -d "${1:a}" ]]; then
		printf >&2 \
				"%s: functions missing, try reinstalling with \`brew reinstall %s\`\n" \
				"${name}" "${name}"
		return 1
	fi

	builtin autoload -Uz ${1:a}/*(:t)

	if [[ "$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)" != "10" ]]; then
		declare -grx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
			MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) \
			BOLD=$(tput bold) DIM=$(tput dim) \
			CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
	fi
}

_update_line() {
	local \
		line="${1}" \
		file="${2}" \
		pat="${3}" \
		lines=""

	echo "Checking ${file:t}..."
	if [[ -f "${file}" ]]; then
		if [[ -n "${pat}" ]]; then
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
	[[ -f "${file}" ]] && echo >> "${file}"
	while read -r l; do
		echo "  ${l}"
		echo "${l}" >> "${file}";
	done <<< "${line}"

	echo "Done"
}

_initsrc() {
	cat << EOF
# benmoose/cli-utils
brew list --formulae cli-utils &>/dev/null && source $(__NAME__ --zsh)
EOF
}

_install () {
	local dest
	[[ "${SHELL}" =~ zsh$ ]] && dest=${ZDOTDIR:-~}/.zshrc || dest=${HOME:-~}/.bashrc
	
	if [[ ! -f "${dest}" || ! -w "${dest}" ]]; then
		echo "error: .zshrc is missing or unwritable"
		return 1
	fi

	_update_line "$(_initsrc)" "${dest}" "${name} --zsh"
}

_cli_utils_main() {
	emulate -L zsh
	set -u

	[[ $# == 3 ]] || return 1

	declare -r name="${1}" op_arg="${2}" fn_dir="${3:a}"

	if [[ "${op_arg}" == "--zsh" ]]; then
		_init_func "${fn_dir:a}"
		return $?
	fi

	if [[ "${op_arg}" == "--init" ]]; then
		_install
		return $?
	fi
}

{
	[[ $# == 1 ]] && \
		# _cli_utils_main "${0:t}" "${1:l}" "/opt/homebrew/opt/cli-utils/share/cli-utils/"
		_cli_utils_main "${0:t}" "${1:l}" "__OPT_PKGSHARE__"
} always {
	unset -f _cli_utils_main _init_func _update_line _initsrc _install
}

return $?
