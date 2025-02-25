SHELL := bash

.PHONY: all
all: dot

.PHONY: dot
dot: ## install dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".github" -not -name ".config" -not -name ".*.swp" -not -name ".gnupg" -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \

	ln -sfn $(CURDIR)/gitignore $(HOME)/.gitignore

	mkdir -p $(HOME)/.config
	for prg in helix ghostty; do \
		ln -sfn $(CURDIR)/.config/$$prg $(HOME)/.config/$$prg; \
	done; \

	mkdir -p $(HOME)/.config/fish
	for file in $(shell find $(CURDIR)/.config/fish -name "*.fish" -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.config/fish/$$f; \
	done; \

.PHONY: test
test:  ## run all tests
	docker run --rm -i $(DOCKERFLAGS) \
		--name dot-shellcheck \
		-v $(CURDIR):/src:ro \
		shinomineko/shellcheck ./test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
