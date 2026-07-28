#!/usr/bin/env zsh

set -o pipefail

function com {
    if ! ,git_repo; then return 1; fi

    git checkout -q "$(,git_main_branch)"
}

function cos {
    if ! ,git_repo; then return 1; fi

    git checkout -q staging
}

function rbm {
    setopt LOCAL_OPTIONS LOCAL_TRAPS NO_MONITOR
    if ! ,git_repo; then return 1; fi

    declare -r main_b="$(,git_main_branch)" curr_b="$(,git_current_branch)" \
        CR="$(\tput cr)" EL="$(\tput el)" NS="$(\tput sgr0)" RED="$(\tput setaf 1)" GREEN="$(\tput setaf 2)"

    if [[ "${main_b}" == "${curr_b}" ]]; then ,err "$0: not on a feature branch"; return 1; fi

    (git fetch -q && git rebase -q "origin/${main_b}") & declare -r pid="${!}"
    trap 'kill "${pid}"; return 130' INT TERM

    declare -r msg="rebase onto origin/${main_b}..."
    ,spinner "${pid}" "${msg}..."

    if ! \wait "${pid}" 2>/dev/null; then
        \printf "%s${RED}✕${NS} %s error.\n" "${CR}${EL}" "${msg}"
        return 1
    else
        \printf "%s${GREEN}✔${NS} %s done.\n" "${CR}${EL}" "${msg}"
    fi
 }

function ,git_repo {
    if ! command git rev-parse --git-dir --quiet &>/dev/null; then
        [[ "$1" != "-q" ]] && ,err "$0: not in git repository"
        return 1
    fi
}

function ,git_main_branch {
    if ! ,git_repo; then return 1; fi

    declare ref remote
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
        if command git show-ref --verify --quiet "${ref}"; then
            echo "${ref:t}"
            return 0
        fi
    done

    for remote in origin upstream; do
        ref="$(command git rev-parse --abbrev-ref ${remote}/HEAD 2>/dev/null)"
        if [[ "${ref}" == "${remote}/*" ]]; then
            echo "${ref#${remote}/}"
            return 0
        fi
    done

    echo "master"
    return 1
}

function ,git_current_branch {
    if ! ,git_repo; then return 1; fi

    command git symbolic-ref --short --quiet HEAD 2>/dev/null
}
