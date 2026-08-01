#!/usr/bin/env bash

declare -U fpath

declare -r fn_dir="$1"

if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	fpath+=("${fn_path}")

	echo "${fn_path}/*" | xargs -n 1 autoload -Uz
fi
