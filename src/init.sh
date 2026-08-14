#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

emulate -L zsh

export -TU FPATH fpath

local \
	_fn_dir="<<FN_DIR>>" \
	_fn_fallback="${0:A:h}/../share/cli-utils/functions"

if [[ -z ${fpath[(r)${_fn_dir}]} ]]; then
	if [[ -d "${_fn_dir}" ]]; then
		fpath+=("${_fn_dir}")
	elif [[ -d "${_fn_fallback:A}" ]]; then
		printf >&2 "%s: using fallback directory \`%s\`\n" "${0:t}" "${_fn_fallback:A}"
		_fn_dir="${_fn_fallback:A}"
		fpath+=("${_fn_dir}")
	else
		printf >&2 "%s: unable to find cli-util functions, bad install? Try \`brew reinstall cli-utils\`\n" "${0:t}"
		false
	fi
fi

for fn_file in "${fn_dir}"/*; do
	emulate zsh -c "autoload -Uz -- ${fn_file:t}"
done

unset _fn_dir _fn_fallback

if [[ "$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)" == "10" ]]; then
	declare -rx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
		MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) \
		BOLD=$(tput bold) DIM=$(tput dim) \
		CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
fi
