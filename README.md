# CLI Utils

## Quickstart

Homebrew installation:

```sh
brew install benmoose/cli-utils/cli-utils
install-cli-utils
```

Or `brew tap benmoose/cli-utils` and then `brew install cli-utils`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "benmoose/cli-utils"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).


## Contributing

### Tree view

```
.
├── bin
│   └── install-cli-utils -> ../libexec/install.zsh
├── init -> share/cli-utils/init.zsh
├── INSTALL_RECEIPT.json
├── libexec
│   └── install.zsh
├── LICENSE
├── README.md
├── sbom.spdx.json
└── share
    ├── cli-utils
    │   ├── init-env.zsh
    │   ├── init.zsh
    │   └── spinners.txt
    └── zsh
        └── site-functions
            ├── _err
            ├── _git_current_branch
            ├── _git_main_branch
            ├── _git_repo
            ├── _spinner
            ├── com
            ├── cos
            ├── gppl
            ├── gsy
            ├── gtop
            ├── gvel
            ├── rbm
            ├── rsm
            ├── rss
            ├── stage
            ├── uuid
            ├── vpr
            └── vr

7 directories, 28 files
```

### Updating formula

Get sha256 of formula url:

```sh
brew info --json --formula cli-utils | jq '.[].urls.stable.url'
```
