# _err [<msg>] - Print <msg> to stderr

builtin emulate -L zsh

builtin printf "$RED%s$NS\n" "$*" >&2
