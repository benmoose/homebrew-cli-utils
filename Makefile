SHELL := /usr/bin/env zsh
default: help

.PHONY: fmt
fmt: install ## Check format of zsh scripts and functions
	@zsh-lint ./src/*.zsh ./src/public/* ./src/private/*

.PHONY: install
install:
	@go install github.com/z-shell/zsh-lint/cmd/zsh-lint@latest

.PHONY: help
help:  ## Print this help message
	@printf "Available targets:\n" && \
		egrep -h '\s##\s' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;34m    %-12s\033[0m %s\n", $$1, $$2}'
