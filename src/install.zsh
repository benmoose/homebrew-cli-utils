#!/usr/bin/env zsh
[[ -n "$ZSH_VERSION" ]] || (
	builtin printf "fatal: expect zsh shell\n" >&2
	exit 1
)
emulate -L zsh -o err_return
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
	  local _b=$(builtin tput bold) _d=$(tput dim) _ns=$(tput sgr0)
		builtin printf "${_d}╭╴${_ns}${_b}%s already configured for cli-utils:${_ns}\n" "${file:t}"

		command echo "$matched" | awk \
			-v d="$_d" -v n="$_ns" -v w="$(wc -l <"$file" | wc -c)" \
			-F: '/^[0-9]+:/ {printf "%s╰╴%-*d:%s%s\n", d, w, n, $1, substr($0, index($0, ":") + 1); next} {print}'

    return 0
	fi

	if ! [[ -f "$file" && -w "$file" ]]; then
		builtin printf "%s is not a writable file" "${file:t}" >&2
		return 1
	fi

  local -i written
	if [[ -n $(command tail -n1 "$file") ]]; then
    builtin echo >> "$file" && \
      ((++written))
  fi

	while read -r l; do
		builtin echo "$l" >> "$file" && \
      ((++written))
	done <<<"$line\n"

  builtin printf "%s written, %d lines added\n" "${dotfile:t}" "$written"
  (( written ))
}

_install() {
	local -r \
		pattern="source \"$(brew --prefix cli-utils)/init.zsh\"" \
		dotfile="${ZDOTDIR:-$HOME}/.zshrc"

	if [[ ! -f "$dotfile" || ! -w "$dotfile" ]]; then
		builtin printf "%s: %s is missing or unwritable\n" "${1:t}" "${dotfile:t}" >&2
		return 1
	fi

	_append_file "$dotfile" "$pattern" cat <<~EOS
# Load cli-utils
${pattern}
EOS
}

{
	[[ "${zsh_eval_context[-1]}" == "file" ]] && (
		builtin printf "run %s from your shell or via a script\n" "${0:t}" >&2
		return 1
	)
	_install "${0:a}"
} always {
	unset -f _append_file _install
}
