#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

emulate -L zsh
set -o errexit

local -r fn_dir="${0:A:h}/functions"

if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	declare -rx RED=$(\tput setaf 1) GREEN=$(\tput setaf 2) YELLOW=$(\tput setaf 3) BLUE=$(\tput setaf 4) \
		MAGENTA=$(\tput setaf 5) CYAN=$(\tput setaf 6) DEFAULT=$(\tput setaf 9) \
		BOLD=$(\tput bold) DIM=$(\tput dim) \
		CR=$(\tput cr) EL=$(\tput el) CIVIS=$(\tput civis) CNORM=$(\tput cnorm) NS=$(\tput sgr0)

	if ! [[ -d "${fn_dir}" ]]; then
		printf >&2 "%s%s: expected to find directory at %s, try reinstalling benmoose/cli-utils%s\n" "${RED}" "${0}" "${fn_dir}" "${NS}"
		return 1
	fi

	fpath+=("${fn_dir}")

	for fn_file in "${fn_dir}"/*; do
		emulate zsh -c "autoload -Uz -- ${fn_file:t}"
	done
fi
