#!/usr/bin/env zsh
[[ -n "$ZSH_VERSION" ]] || (
	builtin printf "fatal: expect zsh shell\n" >&2
	exit 1
)
emulate -L zsh

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
[[ -n "$CLI_UTILS_DIR" ]] || declare -gxr CLI_UTILS_DIR="${0:a:h}"

_init() {
	local -r func_dir="${1:h}/share/zsh/site-functions"
	if ! [[ -d "$func_dir" ]]; then
		builtin printf \
			"%s: installed functions not found, expect directory at %s.\nTry running '%q'\n" \
			"${1:t}" "$func_dir" "brew reinstall cli-utils" >&2
		return 1
	fi

	export -TU FPATH fpath
	[[ -n "${fpath[(r)$func_dir]-}" ]] || fpath+=( " ${func_dir}" )
	builtin autoload -Uz "$func_dir"/*(:t)
	source "${1:h}/share/cli-utils/env.zsh"
}

{
	[[ "${zsh_eval_context[-1]}" == "file" ]] || return 1

	_init "${0:a}"
} always {
	unset -f _init
}
