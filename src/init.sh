#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

if [[ -z "${ZSH_VERSION-}" ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

if [[ "${zsh_eval_context[-1]:-toplevel}" != "file" ]]; then
	command printf "${0:t}: must be sourced, not executed\n" >&2
	exit 1
fi

_dotfile() {
	if [[ -e ${ZDOTDIR:-~}/.zshrc(:a) ]] || [[ "${SHELL-}" == *zsh ]]; then
		echo ${ZDOTDIR:-~}/.zshrc(:a)
	else
		echo ${HOME:-~}/.bashrc(:a)
	fi
}

_init() {
	local -r name="${1}" fn_dir="${2}"

	if [[ ! -d "${fn_dir}" ]]; then
		command printf \
			"%s: functions not found, try reinstalling ${2} with \`brew reinstall %s\`\n" \
			"${name}" "${name}" >&2
		return 1
	fi

	export -U FPATH fpath
	if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
		fpath+=("${fn_dir}")
	fi

	builtin autoload -Uz ${fn_dir}/*(:t)
	command printf "%s: autoloading complete\n" "${name}"

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
		matched

	command printf "Checking %s...\n" "${file:t}"
	if [[ -f "${file}" ]]; then
		if [[ -n "${pat}" ]]; then
			matched=$(command grep -nF "${pat}" ${file})
		else
			matched=$(command grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	if [[ -n "${matched}" ]]; then
		command printf "  found pattern match in file\n"
		command sed 's/^/    → /' <<<"${matched}"
		return
	fi

	if ! [[ -f "${file}" && -w "${file}" ]]; then
		command printf "%s is not a writable file\n" "${file:t}" >&2
		return 1
	fi

	local file_backup=$(mktemp -q -t="${file:t}-backup")
	builtin trap 'rm -rf "${file_backup}"' EXIT
	if [[ $? -ne 0 ]]; then
		command printf "fatal: failed to create temp file, exiting..." >&2
		return 1
	fi
	cat "${file}" >"${file_backup}"
	builtin trap 'cat "${file_backup}" > "${file:h}/.zshrc-backup"; return 130' INT TERM

	command printf "Writing to %s:\n" "${file:t}"
	[[ -n "$(command tail -n 1 ${file})" ]] && builtin print >>"${file}"

	while read -r src_line; do
		command printf "  %s\n" "${src_line}"
		builtin print "${src_line}" >>"${file}"
		((added++))
	done <<<"${line}"

	command printf "Finished writing to %s. Added %s lines.\n" "${file:t}" "$(cat ${line} | wc -l)"
}

_source_src() {
	cat <<EOF
# benmoose/cli-utils
brew list --formulae ${1} &>/dev/null && source \$(${1} --zsh)
EOF
}

_install() {
	local -r name="${1}" dest="$(_dotfile)"

	if [[ ! -f "${dest}" || ! -w "${dest}" ]]; then
		command printf "error: %s is missing or unwritable" "${dest:t}" >&2
		return 1
	fi

	local -r src="$(_source_src ${name})"
	command printf "%s: src::\n\n%s\n\n" "${name}" "${src}"

	_update_line "${src}" "${dest}" "source (${name} --zsh)"
}

_cli_utils_main() {
	emulate -L zsh
	set -u

	[[ $# == 3 ]] || return 1

	declare -r name="${1}" op_arg="${2:l}" fn_dir="${3:a}"

	if [[ "${op_arg}" == "--install" ]]; then
		_install "${name}"
		return $?
	fi

	if [[ "${op_arg}" == "--zsh" ]]; then
		_init "${name}" "${fn_dir}"
		return $?
	fi

	command printf "%s: unexpected param '%s'\n" "${name}" "${op_arg}" >&2
	return 1
}

{
	if [[ $# != 1 ]]; then
		command printf "%s: missing required param\n" "${0:t}" >&2
		return 1
	fi

	0="${ZERO:-${${0:#${ZSH_ARGZERO}}:-${(%):-%N}}}"

	_cli_utils_main "${0:a:t}" "${1-}" "__OPT_PKGSHARE__"
} always {
	unset -f _cli_utils_main _init _install _update_line _source_src _dotfile

	(( TRY_BLOCK_ERROR = 0 ))
}
