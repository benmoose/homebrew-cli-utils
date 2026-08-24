#!/usr/bin/env zsh
# Must be executed (not sourced) from an interactive zsh, e.g. in .zshrc

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

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
		command printf "%s is not a writable file\n" "${file:t}" >&2
		return 1
	fi

	[[ -n "$(command tail -n 1 ${file})" ]] && command printf "\n" >>"${file}"
	while read -r src_line; do
		builtin print "${src_line}" >>"${file}"
	done <<<"${line}\n"

	command printf "%s updated: %s lines added\n" "${file:t}" "$(wc -l <<<${line})"
}

_install() {
	emulate -L zsh
	set -u
	local -r name="${1:t}" prefix="${HOMEBREW_PREFIX}/opt/cli-utils"

	command printf "0:%s\na:%s\nA:%s\n" "${0}" "${0:a}" "${0:A}"

	local dotfile="${ZDOTDIR:-${HOME:-~}}/.zshrc"
	if [[ ! -f ${dotfile} || ! -w ${dotfile} ]]; then
		command printf "%s: %s is missing or unwritable\n" "${name}" "${dotfile:t}" >&2
		return 1
	fi

	local -r \
		pattern="source \"${prefix}/init.zsh\""
		src=$(
			cat <<EOS
# cli-utils
${pattern}
EOS
	)
	_update_line "${src}" "${dotfile}" "${pattern}"
}

{
	0="${ZERO:-${${0:#${ZSH_ARGZERO}}:-${(%):-%N}}}"

	if _is_sourced; then
		command printf "%s: execute directly or via a script\n" "${0:t}" >&2
		return 1
	fi

	_install "${0:a}" &&
		source "$(brew --prefix cli-utils)/init"
} always {
	unset -f  _update_line _is_sourced _install
}
