#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

local -r fn_dir="${0:A:h}/functions"

if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	declare -rx RED=$(\tput setaf 1) GREEN=$(\tput setaf 2) YELLOW=$(\tput setaf 3) \
		CYAN=$(\tput setaf 6) BOLD=$(\tput bold) DIM=$(\tput dim) NS=$(\tput sgr0) \
		CR=$(\tput cr) EL=$(\tput el) CIVIS=$(\tput civis) CNORM=$(\tput cnorm)

	fpath+=("${fn_dir}")

	for fn_file in "${fn_dir}"/*; do
		autoload -Uz -- "${fn_file:t}"
	done
fi
