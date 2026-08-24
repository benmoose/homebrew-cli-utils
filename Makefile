default: help

.PHONY: fmt
fmt: ## Format shell scripts and functions
	shfmt -ln zsh -w src/**/*

.PHONY: help
help:  ## Print this help message
	@printf "Available targets:\n" && \
		egrep -h '\s##\s' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;34m    %-12s\033[0m %s\n", $$1, $$2}'
