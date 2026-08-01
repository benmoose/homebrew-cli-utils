#!/usr/bin/env zsh

declare -UT FPATH=$FPATH fpath

declare -r fn_dir="$1"

if [[ -z ${FPATH[(r)${fn_dir}]} ]]; then
	fpath=(${fn_path} $fpath)
	autoload -Uz ${fn_path}/*(:t)
fi
