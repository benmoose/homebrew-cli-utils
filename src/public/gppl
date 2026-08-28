# gppl - (git-people) List the repo's top contributors over the last year
# See https://piechowski.io/post/git-commands-before-reading-code

builtin emulate -L zsh
set -o pipefail

if ! _git_repo; then return 1; fi

git shortlog --no-merges --numbered --since="1 year ago" --summary | cat
