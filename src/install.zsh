#!/usr/bin/env zsh

0="${${(M)0:#/*}:-$PWD/$0}"

if [[ -z "${ZSH_VERSION-}" ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

_err() {
	command printf "$(\tput setaf 1)cli-utils (install): %s$(\tput sgr0)\n" \
		"$@" >&2
}

_is_sourced() {
	[[ "$zsh_eval_context" == *file* ]]
}

_append_file() {
	local \
		line="$1" \
		file="$2" \
		pat="$3" \
		matched=""

	if [[ -f "$file" ]]; then
		if [[ -n "$pat" ]]; then
			matched=$(command grep -n "$pat" "$file")
		else
			matched=$(command grep -nF "${line#"${line%%[![:space:]]*}"}")
		fi
	fi

	if [[ -n "$matched" ]]; then
		local bold=$(\tput bold) blue=$(tput setaf 4) dim=$(\tput dim) ns=$(\tput sgr0)
		local -i width=$(tail -n 1 <<<"$matched" | sed 's/:.*$//g' | wc -L)
		command printf "${blue}${bold}✓${ns} ${blue}${bold}Found cli-utils in %s already:${ns}\n" "${file:t}"
		command tail -n 10 <<<"$matched" | command awk \
			-v w="$width" -v b="$bold" -v d="$dim" -v n="$ns" \
			-F: '/^[0-9]+:/ {printf "%s╰╴%*d%s %s%s%s\n", d, w, $1, n, b, n, substr($0, index($0, ":") + 1); next} {print}'
		command printf "${bold}No changes needed, done.${ns}\n"
		return 0
	fi

	if ! [[ -f "$file" && -w "$file" ]]; then
		_err "${file:t} is not a writable file"
		return 1
	fi

	if [[ -n $(command tail -n 1 "$file") ]]; then
		builtin echo >>"$file"
	fi

	while read -r src_line; do
		builtin print "$src_line" >>"$file"
	done <<< "$line\n"

	command printf "%s updated, added %s lines\n" "${file:t}" "$(grep -c "" "$file")"
}

_install() {
	emulate -L zsh
	set -u
	source "$PREFIX/share/cli-utils/init-env.zsh"
	local -r \
		pattern="source $PREFIX/init" \
		dotfile="${ZDOTDIR:-${HOME:-~}}/.zshrc"

	if [[ ! -f "$dotfile" || ! -w "$dotfile" ]]; then
		_err "${dotfile:t} is missing or unwritable"
		return 1
	fi

	local -r src=$(
		cat <<EOS
# Load ${PREFIX:t}
${pattern} "${PREFIX:a}"
EOS
	)

	_append_file "$src" "$dotfile" "$pattern"
}

{
	if _is_sourced; then
		_err "execute directly or via a script"
		return 1
	fi

	PREFIX="$(brew --prefix cli-utils)" _install
} always {
	unset -f _err _is_sourced _append_file _install
}
