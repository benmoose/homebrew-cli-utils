#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

local -r fn_dir="${0:A:h}/functions"

if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	fpath+=("${fn_dir}")

	for fn_file in "${fn_dir}"/*; do
		autoload -Uz -- "${fn_file:t}"
	done
fi
