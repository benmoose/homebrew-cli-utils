#!/usr/bin/env zsh

set -o pipefail

function com {
	if ! ,is_git_repo; then return 1; fi

	eval "git checkout --quiet $(,git_main_branch)"
}

function cos {
	if ! ,is_git_repo; then return 1; fi

	eval 'git checkout --quiet staging'
}

function rbm {
	if ! ,is_git_repo; then return 1; fi

	local -r main_b="$(,git_main_branch)" curr_b="$(,git_current_branch)"
	if [[ "${main_b}" == "${curr_b}" ]]; then
		,err "$0: not on a feature branch"
		return 1
	fi

	setopt LOCAL_OPTIONS LOCAL_TRAPS NO_MONITOR
	(git fetch -q && git rebase -q "origin/${main_b}") & declare -r pid="${!}"
	trap 'kill "${pid}"; return 130' INT TERM

	local -r msg="rebase onto origin/${main_b}..."
	,spinner "${pid}" "${msg}..."

	if \wait "${pid}" 2>/dev/null; then
		printf "%s${GREEN}✔${NS} %s done.\n" "${CR}${EL}" "${msg}"
	else
		printf "%s${RED}✕${NS} %s error.\n" "${CR}${EL}" "${msg}"
		return 1
	fi
}

function vr {
	if ! ,is_git_repo; then return 1; fi
	if ! which gh &>/dev/null; then ,err "$0: command gh not found"; return 127; fi

	setopt LOCAL_OPTIONS LOCAL_TRAPS NO_MONITOR

	local -r branch_arg="${1:-$(,git_current_branch)}"

	(gh repo view --branch "${branch_arg}" --web) >/dev/null &
	readonly pid="${!}"
	trap 'kill "${pid}"; return 130' INT TERM

	,spinner "${pid}" "Opening repository... "
	if wait "${pid}" 2>/dev/null; then printf "${CR}${EL}"; fi
}

function vpr {
	if ! ,is_git_repo; then return 1; fi
	if ! which gh &>/dev/null; then ,err "$0: command gh not found"; return 127; fi

	setopt LOCAL_OPTIONS LOCAL_TRAPS NO_MONITOR

	(gh pr view --web) >/dev/null & local pid="${!}"
	trap 'kill "${pid}"; return 130' INT TERM

	local -r msg="Opening pull request #$(gh pr view --json number --jq '.number')..."

	,spinner "${pid}" "${msg} " $(tput setaf 4)
	if wait "${pid}" 2>/dev/null; then
		printf "%s%s✓%s ${msg} done.\n" "${CR}${EL}" "${GREEN}" "${NS}" 
	fi
}

function ,is_git_repo {
	if ! git rev-parse --git-dir &>/dev/null; then
		[[ "$1" != "-q" ]] && ,err "$0: not in git repository"

		return 1
	fi
}

function ,git_repo {
	if ! ,is_git_repo; then return 1; fi

	basename $(git rev-parse --show-toplevel --quiet)
}

function ,git_main_branch {
	if ! ,is_git_repo; then return 1; fi

	declare ref remote
	for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
		if git show-ref --verify --quiet "${ref}" 2>/dev/null; then
			echo "${ref:t}"

			return 0
		fi
	done

	for remote in origin upstream; do
		ref=$(git rev-parse --abbrev-ref --quiet ${remote}/HEAD 2>/dev/null)
		if [[ "${ref}" == ${remote}/* ]]; then
			echo "${ref#${remote}/}"
			return 0
		fi
	done

	echo "master"
	return 1
}

function ,git_current_branch {
	if ! ,is_git_repo; then return 1; fi

	git symbolic-ref --short --quiet HEAD 2>/dev/null
}
