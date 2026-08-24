#!/usr/bin/env zsh
if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

_err() {
	command printf "$(\tput setaf 1)cli-utils (install): %s$(\tput sgr0)\n" \
		"$@" >&2
}

_is_sourced() {
	for ctx in ${zsh_eval_context}; do
		if [[ "${ctx}" == "file" ]]; then return 0; fi
	done
	return 1
}

_append_file() {
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
		command printf "$(\tput bold)%s contains matching line:$(\tput sgr0)\n" "${file:t}"
		command sed 's/^/└ /' <<<"${matched}"
		command printf "No changes made.\n"
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

	local -r \
		pattern="source ${1}/init"
	dotfile="${ZDOTDIR:-${HOME:-~}}/.zshrc"
	if [[ ! -f ${dotfile} || ! -w ${dotfile} ]]; then
		_err "${dotfile:t} is missing or unwritable"
		return 1
	fi

	local -r src=$(
		cat <<EOS
# Load ${1:t} (v ${1:A:t})
${pattern} "${1:a}"
EOS
	)

	_append_file "${src}" "${dotfile}" "${pattern}"
}

{
	if _is_sourced; then
		_err "execute directly or via a script"
		return 1
	fi

	_install "$(brew --prefix cli-utils)"
} always {
	unset -f  _append_file _is_sourced _err _install
}
