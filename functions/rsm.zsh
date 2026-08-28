# rsm - Reset the local main branch to the remote branch

builtin emulate -L zsh

if ! _git_repo; then return 1; fi

0="${${(M)0:#/*}:-$PWD/$0}"
local -r main_b="$(_git_main_branch)" curr_b="$(_git_current_branch)"

if [[ "$main_b" != "$curr_b" ]]; then
	_err "${0:t}: not on $main_b branch"
	return 1
fi

setopt no_monitor

() {
	git fetch -q --no-auto-gc --no-tags && git reset -q --hard "origin/${main_b}"
} &
local -r pid="${!}"
trap 'kill "$pid"; return 130'

local -r msg="reset to origin/$main_b"
_spinner "$pid" "$msg"

if ! wait "$pid" 2>/dev/null; then
	printf "${CR}${EL}${RED}×${NS} %s error\n" "$msg"
	return 1
fi

printf "${CR}${EL}${GREEN}✓${NS} %s done\n" "$msg"
