# Benmoose Cli-utils

## How do I install these formulae?

`brew install benmoose/cli-utils/cli-utils`

Or `brew tap benmoose/cli-utils` and then `brew install cli-utils`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "benmoose/cli-utils"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).


## Contributing

### Updating formula

Get sha256 of formula url:

```sh
brew info --json --formula cli-utils | jq '.[].urls.stable.url'
```
