default: help

SHELL := /usr/bin/env zsh
.SHELLFLAGS := -eu -o pipefail -c

export GO111MODULE=on
GO ?= go
GOPATH ?= $(shell $(GO) env GOPATH)
GOBIN ?= $(GOPATH)/bin

.PHONY: fmt
fmt: ## Check format of zsh scripts and functions
	@for file in $(shell find . -name '*.zsh' -type f) ; do \
		zsh -f -n -- "$$file"; \
	done
	@$(GOBIN)/zsh-lint functions/*.zsh functions/private/*.zsh

.PHONY: install
install: $(GOBIN)/zsh-lint
	@echo "Installing..."
	@$(GO) install github.com/z-shell/zsh-lint/cmd/zsh-lint@latest

.PHONY: help
help:  ## Print this help message
	@printf "Available targets:\n" && \
		egrep -h '\s##\s' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;34m    %-12s\033[0m %s\n", $$1, $$2}'
