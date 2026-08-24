#!/usr/bin/env zsh
# Must be sourced (not executed) from an interactive zsh, e.g. in .zshrc

if [[ -z ${ZSH_VERSION-} ]]; then
	command printf "${0:t}: expect zsh shell\n" >&2
	false
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

	local -r func_dir="${1:a}/share/zsh/site-functions"
	if ! [[ -d "${func_dir}" ]]; then
		command printf \
			"fatal: installed functions not found, expect directory at %s. Try running \"brew reinstall cli-utils\"\n" \
			"${func_dir}" >&2
		return 1
	fi

	if [[ "$(env | egrep 'RED|GREEN|YELLOW|BLUE|CYAN|BOLD|DIM|CR|EL|NS' -wc)" != "10" ]]; then
		declare -grx RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) BLUE=$(tput setaf 4) \
		MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) \
		BOLD=$(tput bold) DIM=$(tput dim) \
		CR=$(tput cr) EL=$(tput el) CIVIS=$(tput civis) CNORM=$(tput cnorm) NS=$(tput sgr0)
	fi

	builtin autoload -Uz ${func_dir}/*(:t)
}

{
	_is_sourced &&
		_init "${HOMEBREW_PREFIX}/opt/cli-utils"
} always {
	unset -f _is_sourced _init
}
