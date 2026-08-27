#!/usr/bin/env zsh
emulate -L zsh
0="${(%):-%N}"

if [[ -z "$ZSH_VERSION" ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	return 1
fi

_init() {
	local -r func_dir="${1:h}/share/zsh/site-functions"
	if ! [[ -d "$func_dir" ]]; then
		command printf \
			"%s: installed functions not found, expect directory at %s.\nTry running \"brew reinstall cli-utils\"\n" \
			"${1:t}" "$func_dir" >&2
		return 1
	fi

	export -TU FPATH fpath
	[[ -n "${fpath[(r)$func_dir]-}" ]] || fpath+=( "${func_dir}" )
	builtin autoload -Uz "$func_dir"/*(:t)
	source "${1:h}/share/cli-utils/init-env.zsh"
}

{
	[[ "${zsh_eval_context[-1]}" == "file" ]] || return 1
	_init "$0"
} always {
	unset -f _init
}
