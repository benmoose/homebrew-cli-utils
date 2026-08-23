#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc:
#   source "/path/to/init.sh"

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	exit 1
fi

_is_sourced() {
	for ctx in ${zsh_eval_context}; do
		if [[ "${ctx}" == "file" ]]; then return 0; fi
	done
	return 1
}

_init() {
	emulate -L zsh
	set -u
	# local -r name="${1}" fn_dir="${2:a}"

	# if [[ ! -d ${fn_dir} ]]; then
	# 	command printf \
	# 		"%s: functions not found, try reinstalling ${2} with \`brew reinstall %s\`\n" \
	# 		"${name}" "${name}" >&2
	# 	return 1
	# fi

	# export -U FPATH fpath
	# if [[ -z ${fpath[(r)${fn_dir}]} ]]; then
	# 	fpath+=("${fn_dir}")
	# fi

	# builtin autoload -Uz ${fn_dir}/*(:t)
	# command printf "%s: autoloading complete\n" "${name}"

	if [[ "$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)" != "10" ]]; then
		declare -grx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
		MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) \
		BOLD=$(tput bold) DIM=$(tput dim) \
		CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
	fi
}

{
	_is_sourced && _init

	# _init "${0:a:t}" "__OPT_PKGSHARE__"
} always {
	unset -f _is_sourced _init
}
