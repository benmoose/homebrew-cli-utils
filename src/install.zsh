#!/usr/bin/env zsh
if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

_err() {
	[[ "${1}" == "-x" ]] && (
		shift
		false
	)
	command printf "$(\tput setaf 1)cli-utils: (install) %s$(\tput sgr0)\n" \
		"$@" >&2
}

_is_sourced() {
	for ctx in ${zsh_eval_context}; do
		if [[ "${ctx}" == "file" ]]; then return 0; fi
	done
	return 1
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
		command printf "%s contains matching line:\n" "${file:t}"
		command sed 's/^/└ /' <<<"${matched}"
		return
	fi

	if ! [[ -f ${file} && -w ${file} ]]; then
		_err "${file:t} is not a writable file"
		return 1
	fi

	[[ -n "$(command tail -n 1 ${file})" ]] && command printf "\n" >>"${file}"
	while read -r src_line; do
		builtin print "${src_line}" >>"${file}"
	done <<<"${line}\n"

	command printf "%s updated, added %s lines\n" "${file:t}" "$(wc -l <<<${line})"
}

_install() {
	emulate -L zsh
	set -u
	_err "demo err msg"
	_err -x "demo err that returns (hopefully)"

	local -r \
		prefix="${HOMEBREW_PREFIX}/opt/cli-utils" \
		dotfile="${ZDOTDIR:-${HOME:-~}}/.zshrc"

	if [[ ! -f ${dotfile} || ! -w ${dotfile} ]]; then
		_err "${dotfile:t} is missing or unwritable"
		return 1
	fi

	local -r \
		pattern="source \"${prefix}/init\"" \
	src=$(
		cat <<EOS
# Autoload cli-utils functions
${pattern}
EOS
	)

	_update_line "${src}" "${dotfile}" "${pattern}"
}

{
	if _is_sourced; then
		_err "execute directly or via a script"
		return 1
	fi

	_install
} always {
	unset -f  _update_line _is_sourced _err _install
}
