#!/usr/bin/env zsh

function ,err {
    delcare -r RED="$(\tput setaf 1)" NS="$(\tput sgr0)"

    printf "%s%s%s\n" "${RED}" "${*}" "${NS}" 1>&2
}
