# rss - Reset the local staging branch to the remote branch

builtin emulate -L zsh

if ! _git_repo; then return 1; fi

0="${${(M)0:#/*}:-$PWD/$0}"
if [[ "$(_git_current_branch)" != "staging" ]]; then
	_err "${0:t}: not on staging branch"
	return 1
fi

setopt no_monitor

() {
	git fetch -q --no-auto-gc --no-tags && git reset -q --hard origin/staging
} &
local -r pid="${!}"
trap 'kill "${pid}"; return 130'

local -r msg="reset staging branch to origin"
_spinner "$pid" "$msg" "$YELLOW"

if ! wait "${pid}" 2>/dev/null; then
	printf "${CR}${EL}${BOLD}${RED}×${NS} %s ${BOLD}error${NS}\n" "${msg}"
	return 1
fi

printf "${CR}${EL}${BOLD}${GREEN}✓${NS} %s done\n" "$msg"
