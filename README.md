# CLI Utils

## Quickstart

Homebrew installation:

```sh
brew install benmoose/cli-utils/cli-utils
```

Or `brew tap benmoose/cli-utils` and then `brew install cli-utils`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "benmoose/cli-utils"
brew "cli-utils"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).


## Contributing

### Linter

Install [zsh-lint](https://wiki.zshell.dev/community/zsh_lint) to check zsh scripts locally.

```
go install github.com/z-shell/zsh-lint/cmd/zsh-lint@latest
```

### Tree view

```
.
├── Formula
│   └── cli-utils.rb
├── functions
│   ├── com.zsh
│   ├── cos.zsh
│   ├── gppl.zsh
│   ├── gsy.zsh
│   ├── gtop.zsh
│   ├── gvel.zsh
│   ├── private
│   │   ├── _err.zsh
│   │   ├── _git_current_branch.zsh
│   │   ├── _git_main_branch.zsh
│   │   ├── _git_repo.zsh
│   │   └── _spinner.zsh
│   ├── rbm.zsh
│   ├── rsm.zsh
│   ├── rss.zsh
│   ├── stage.zsh
│   ├── uuid.zsh
│   ├── vpr.zsh
│   └── vr.zsh
├── LICENSE
├── Makefile
├── README.md
└── src
    ├── data
    │   └── spinners.txt
    ├── env.zsh
    ├── init.zsh
    └── install.zsh

6 directories, 26 files
```

### Updating formula

Get sha256 of formula url:

```sh
brew info --json --formula cli-utils | jq '.[].urls.stable.url'
```
