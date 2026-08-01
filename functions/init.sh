#!/usr/bin/env zsh

local pkgshare_arg="${1}" fn_path

declare -ar fn_paths=(${pkgshare_arg}/{private,public})
typeset -U fpath

for fn_path in ${fn_paths}; do
	if [[ -z ${fpath[(r)${fn_path}]} ]]; then
		fpath=(${fn_path} $fpath)
		autoload -Uz ${fn_path}/*(:t)
	fi
done
