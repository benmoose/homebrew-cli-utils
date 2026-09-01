#!/usr/bin/env zsh
[[ -n "$ZSH_VERSION" ]] || (
	builtin printf "fatal: expect zsh shell\n" >&2
	exit 1
)
emulate -L zsh
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"

_append_file() {
	local \
		line="$(</dev/stdin)" \
		file="$1" \
		pat="$2" \
		matched=""

	if [[ -f "$file" ]]; then
		if [[ -n "$pat" ]]; then
			matched=$(command grep -nF "$pat" "$file")
		else
			matched=$(command grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	if [[ -n "$matched" ]]; then
		local _highlight=$(\tput setaf 5) _b=$(\tput bold) _d=$(\tput dim) _ns=$(\tput sgr0)
		builtin printf "▸ It looks like ${_highlight}%s${_ns} already initialises cli-utils:\n" "${file:t}"
		command echo "$matched" | awk \
			-v h="${_highlight}" -v b="${_b}" -v w="$(grep -cF "" "$file" | wc -c | tr -d '[[:space:]]')" \
			-F: '/^[0-9]+:/ {printf "%s   (%*d) %s%s\n", h, w-1, $0, b, substr($0, index($0, ":") + 1); next} {print}'
		printf "${_ns}  ${_d}No change made to ${file:t}${_ns}\n"
		return 0
	fi

	if ! [[ -f "$file" && -w "$file" ]]; then
		builtin printf "%s is not a writable file\n" "${file:t}" >&2
		return 1
	fi

	local -i written
	if [[ -n $(command tail -n1 "$file") ]]; then
		builtin echo >>"$file" &&
			((++written))
	fi

	while read -r l; do
		builtin echo "$l" >>"$file" && ((++written))
	done <<< "${line}\n"
	((written))
}

_install() {
	local -r \
		pattern="source \"${1:a}/init\"" \
		dotfile="${ZDOTDIR:-$HOME}/.zshrc"

	if [[ ! -f "$dotfile" || ! -w "$dotfile" ]]; then
		builtin printf "%s: %s is missing or unwritable\n" "${1:t}" "${dotfile:t}" >&2
		return 1
	fi

	cat <<-EOS | _append_file "$dotfile" "$pattern" || return 1
	# benmoose/cli-utils
	$pattern
	EOS

	source "${1:a}/init"
}

{
	if [[ "${zsh_eval_context[-1]}" == "file" ]]; then
		builtin printf "fatal: run %s from your shell or via a script\n" "${0:t}" >&2
		return 1
	fi

	_install "$(brew --prefix cli-utils)" &&
		printf "✓ Installed cli-utils\n"
} always {
	unset -f _append_file _install
}
