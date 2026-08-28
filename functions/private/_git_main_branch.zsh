# _git_main_branch - returns the main/default branch ref name for the current repository.
builtin emulate -L zsh

if ! _git_repo; then return 1; fi

local ref remote
for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
	if git show-ref --verify --quiet "${ref}"; then
		echo "${ref:t}"
		return 0
	fi
done

for remote in origin upstream; do
	ref=$(git rev-parse --abbrev-ref --quiet "${remote}/HEAD")
	if [[ "$ref" == $remote/* ]]; then
		echo "${ref#${remote}/}"
		return 0
	fi
done

echo "master"
return 1
