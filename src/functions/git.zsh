#!/usr/bin/env zsh

set -o pipefail

function com {
	if ! ,is_git_repo; then return 1; fi

	git checkout --quiet "$(,git_main_branch)"
}

function cos {
	if ! ,is_git_repo; then return 1; fi

	git checkout --quiet staging
}

function rbm {
	if ! ,is_git_repo; then return 1; fi

	declare -r main_b="$(,git_main_branch)" curr_b="$(,git_current_branch)" \
		CR="$(\tput cr)" EL="$(\tput el)" NS="$(\tput sgr0)" RED="$(\tput setaf 1)" GREEN="$(\tput setaf 2)"

	if [[ "${main_b}" == "${curr_b}" ]]; then
		,err "$0: not on a feature branch"
		return 1
	fi

	setopt LOCAL_OPTIONS LOCAL_TRAPS NO_MONITOR
	(git fetch -q && git rebase -q "origin/${main_b}") & declare -r pid="${!}"
	trap 'kill "${pid}"; return 130' INT TERM

	declare -r msg="rebase onto origin/${main_b}..."
	,spinner "${pid}" "${msg}..."

	if ! \wait "${pid}" 2>/dev/null; then
		printf "%s${RED}✕${NS} %s error.\n" "${CR}${EL}" "${msg}"
		return 0
	else
		printf "%s${GREEN}✔${NS} %s done.\n" "${CR}${EL}" "${msg}"
	fi
}

function vr {
	if ! ,is_git_repo; then return 1; fi

	declare -r branch_arg="${1:-$(,git_current_branch)}"

	(gh repo view --branch ${branch_arg} --web) >/dev/null
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
