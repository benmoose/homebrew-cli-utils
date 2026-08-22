#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

_is_source_ctx() {
	[[ ${zsh_eval_context[-1]:-toplevel} == "file" ]]
}

_dotfile() {
	if [[ -e ${ZDOTDIR:-~}/.zshrc(:a) ]] || [[ ${SHELL-} == *zsh ]]; then
		builtin echo ${ZDOTDIR:-~}/.zshrc(:a)
	else
		builtin echo ${HOME:-~}/.bashrc(:a)
	fi
}

_init() {
	local -r name="${1}" fn_dir="${2}"

	if ! _is_source_ctx; then
		command printf "fatal: %s is intended to be sourced, not executed\n" "${name}" >&2
		return 1
	fi

	if [[ ! -d ${fn_dir} ]]; then
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
		matched=""

	if [[ -f ${file} ]]; then
		if [[ -n ${pat} ]]; then
			matched=$(command grep -nF "${pat}" ${file})
		else
			matched=$(command grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	if [[ -n ${matched} ]]; then
		command printf "Found matching line in %s\n" "${file:t}"
		command sed 's/^/    → /' <<<"${matched}"
		return
	fi

	if ! [[ -f ${file} && -w ${file} ]]; then
		command printf "%s is not a writable file\n" "${file:t}" >&2
		return 1
	fi

	command printf "Writing to %s:\n" "${file:t}"
	[[ -n "$(command tail -n 1 ${file})" ]] && command printf "\n" >>"${file}"
	while read -r src_line; do
		builtin print "${src_line}" >>"${file}"
	done <<<"${line}\n"

	command printf "Updated %s: %s lines added.\n" "${file:t}" "$(wc -l <<<${line})"
}

_install() {
	local -r name="${1}" dest="$(_dotfile)"

	if _is_source_ctx; then
		command printf "fatal: %s --install is intended to be executed, not sourced\n" "${name}" >&2
		return 1
	fi

	if [[ ! -f ${dest} || ! -w ${dest} ]]; then
		command printf "%s: %s is missing or unwritable" "${name}" "${dest:t}" >&2
		return 1
	fi

	local -r pattern="source \$(which ${name})"
	local -r src=$(
		cat <<EOS
# benmoose/cli-utils
which ${name} &>/dev/null && ${pattern}
EOS
	)

	_update_line "${src}" "${dest}" "${pattern}"
}

_cli_utils_main() {
	emulate -L zsh
	set -u

	declare -r name="${1}" fn_dir="${2:a}" op_arg="${3:l}"

	if [[ -z ${op_arg} ]]; then
		_init "${name}" "${fn_dir}"
		return $?
	fi

	if [[ ${op_arg} == "--install" ]]; then
		_install "${name}"
		return $?
	fi

	command printf "%s: unexpected param '%s'\n" "${name}" "${op_arg}" >&2
	return 1
}

{
	if [[ $# > 1 ]]; then
		command printf "%s: too many params, expected at most 1\n" "${0:t}" >&2
		return 1
	fi

	0="${ZERO:-${${0:#${ZSH_ARGZERO}}:-${(%):-%N}}}"

	_cli_utils_main "${0:a:t}" "__OPT_PKGSHARE__" "${1-}"
} always {
	unset -f _cli_utils_main _init _install _update_line _dotfile _is_source_ctx
}
