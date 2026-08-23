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
		command sed 's/^    → /' <<<"${matched}"
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
	local -r init_path="${1:h}/init.zsh" name="${1:t}"
	
	command printf "0: %s\n" "${1}"

	[[ -n "${ZDOTDIR-}" ]] && dest="${ZDOTDIR}/.zshrc" || dest="${HOME:-~}/.zshrc"

	if [[ ! -f ${dest} || ! -w ${dest} ]]; then
		command printf "%s: %s is missing or unwritable" "${name}" "${dest:t}" >&2
		return 1
	fi

	local -r pattern="source \"${init_path}\""
	local -r src=$(
		cat <<EOS
# Load cli-utils
${pattern}
EOS
	)

	_update_line "${src}" "${dest}" "${pattern}"
}

{
	0="${ZERO:-${${0:#${ZSH_ARGZERO}}:-${(%):-%N}}}"

	if _is_sourced; then
		command printf "%s: should be executed interactively or by a script\n" "${0:t}" >&2
		return 1
	fi

	_install "${0:a}" &&
		source "${0:a:h}/init.zsh"
} always {
	unset -f _install _update_line _is_sourced
}
