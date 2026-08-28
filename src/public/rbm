# rbm - Rebase against the remote main branch

builtin emulate -L zsh

if ! _git_repo; then return 1; fi

0="${${(M)0:#/*}:-$PWD/$0}"
local -r main_b="$(_git_main_branch)" curr_b="$(_git_current_branch)"

if [[ "${main_b}" == "${curr_b}" ]]; then
	_err "${0:t}: not on a feature branch"
	return 1
fi

setopt no_monitor

() {
	git fetch --quiet && git rebase --quiet "origin/${main_b}"
} &
local -r pid="${!}"
trap 'kill "${pid}"; return 130' INT TERM

local -r msg="rebase onto origin/${main_b}"

_spinner "${pid}" "${msg}"

if wait "${pid}" 2>/dev/null; then
	printf "${CR}${EL}${GREEN}✓${NS} %s done\n" "${msg}"
else
	printf "${CR}${EL}${RED}×${NS} %s error\n" "${msg}"
	return 1
fi
