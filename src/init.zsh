#!/usr/bin/env zsh

0="${(%):-%N}"

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2; return 1
fi

_is_sourced() {
	[[ "$zsh_eval_context" == *file* ]]
}

_init() {
	emulate -L zsh
	set -u
	local -r \
		prefix="${1:=$PREFIX}" \
		func_dir="$PREFIX/share/zsh/site-functions" \
		pkgshare="$PREFIX/share/cli-utils"

	echo "> prefix=$prefix"
	echo "> func_dir=$func_dir"
	echo "> pkgshare=$pkgshare"

	if ! [[ -d "$func_dir" ]]; then
		command printf \
			"fatal: installed functions not found, expect directory at %s. Try running \"brew reinstall cli-utils\"\n" \
			"$func_dir" >&2
		return 1
	fi

	export -TU FPATH fpath
	if [[ -z ${fpath[(r)$func_dir]-} ]]; then
		fpath+=( "${func_dir}" )
	fi

	# if [[ "$(printenv | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|CIVIS|CNORM|NS' -wc)" != "12" ]]; then
	# 	set -a
	# 	source "${pkgshare}/init-env.zsh"
	# 	set +a
	# fi

	builtin autoload -Uz "${func_dir:a}"/*(:t)
}

{
	_is_sourced || return 1

	prefix="$(brew --prefix cli-utils)"
	source "$prefix/share/cli-utils/init-env.zsh"
	PREFIX="$prefix" _init
} always {
	unset -f _is_sourced _init
}
