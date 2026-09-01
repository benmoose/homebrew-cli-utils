# vr [<branch>] - View the repository on GitHub.
builtin emulate -L zsh

if ! _git_repo; then return 1; fi

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${0:a}"

if ! which gh &>/dev/null; then
	_err "${0:t}: command gh not found"
	return 127
fi

local -r branch_arg="${1:-$(_git_current_branch)}"

setopt no_monitor
gh repo view --branch "$branch_arg" --web >/dev/null &
local -r pid="$!"
trap 'kill "$pid"; return 130' INT TERM

_spinner "$pid" "Opening repository"

if builtin wait "$pid" 2>/dev/null; then
	printf "${CR}${EL}${DIM}%s...${NS} done\n" "Opened repository"
fi
