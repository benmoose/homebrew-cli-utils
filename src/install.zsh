#!/usr/bin/env zsh
emulate -L zsh
0="${(%):-%N}"

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	return 1
fi

_err() {
	command printf "$(\tput setaf 1)cli-utils (install): %s$(\tput sgr0)\n" \
		"$@" >&2
}

_append_file() {
	local \
		line="$(</dev/stdin)" \
		file="$1" \
		pat="$2" \
		matched=""

	if [[ -f ${file} ]]; then
		if [[ -n ${pat} ]]; then
			matched=$(command grep -nF "$pat" "$file")
		else
			matched=$(command grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	local -r BOLD=$(builtin tput bold) DIM=$(tput dim) NS=$(tput sgr0)
	if [[ -n ${matched} ]]; then
		command printf "${DIM}╭╴${NS}${BOLD}%s already configured for cli-utils:${DIM}\n" "${file:t}"
		command awk \
			-v d="${DIM}" -v n="${NS}" -v w=$(wc -l <${file} | wc -c) \
			-F: '/^[0-9]+:/ {printf "%s╰╴%-*d:%s%s\n", d, w, n, $1, substr($0, index($0, ":") + 1); next} {print}' <<<"${matched}"
		return
	fi

	if ! [[ -f "$file" && -w "$file" ]]; then
		_err "${file:t} is not a writable file"
		return 1
	fi

	[[ -n $(command tail -n 1 "$file") ]] && command printf "\n" >>"$file"
	while read -r l; do
		builtin print "$l" >>"$file"
	done <<<"$line\n"

	command printf "%s updated, added %s lines\n" "${file:t}" "$(wc -l <<<$line)"
}

_install() {
	local -r \
		pattern="source \"$(brew --prefix cli-utils)/init.zsh\"" \
		dotfile="${ZDOTDIR:-${HOME:-~}}/.zshrc"

	if [[ ! -f "$dotfile" || ! -w "$dotfile" ]]; then
		_err "${1:t}: ${dotfile:t} is missing or unwritable"
		return 1
	fi

	_append_file "$dotfile" "$pattern" <<EOS
# Load ${1:t}
$pattern
EOS
}

{
	if [[ "${zsh_eval_context[-1]}" == "file" ]]; then
		_err "${0:t}: execute directly or via a script"
		return 1
	fi

	_install "$0"
} always {
	unset -f  _append_file _err _install
}
