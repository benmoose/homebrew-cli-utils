#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

emulate -L zsh

local fn fn_arg="$1" \
	fn_dir="$(brew --prefix)/share/zsh/site-functions"

if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	fpath=($fpath "${fn_dir}")
fi

for fn in "${fn_arg}"/*; do
	emulate zsh -c "autoload -Uz ${fn}"
done

local -r tputenv=$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)
if [[ "${tputenv}" == "10" ]]; then
	declare -rx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
		MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) BOLD=$(tput bold) DIM=$(tput dim) \
		CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
fi
