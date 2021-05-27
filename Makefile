SHELL := bash

.PHONY: all
all: bin dot etc

.PHONY: bin
bin: ## install the bin directory files
	for file in $(shell find $(CURDIR)/bin -not -name ".*.swp" -type f); do \
		f=$$(basename $$file); \
		sudo ln -sfn $$file /usr/local/bin/$$f; \
	done

.PHONY: dot
dot: ## install dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".github" -not -name ".config" -not -name ".*.swp" -not -name ".gnupg" -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \

	ln -sfn $(CURDIR)/gitignore $(HOME)/.gitignore

	ln -sfn $(CURDIR)/.config/nvim $(HOME)/.config/nvim

	ln -sfn $(CURDIR)/.config/aria2 $(HOME)/.config/aria2

	gpg --list-keys || true;
	mkdir -p $(HOME)/.gnupg
	for file in $(shell find $(CURDIR)/.gnupg -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.gnupg/$$f; \
	done; \

.PHONY: etc
etc:  ## install the etc directory files
	mkdir -p $(HOME)/.ssh/config.d
	ln -sfn $(CURDIR)/etc/ssh/config $(HOME)/.ssh/config

	sudo ln -sfn $(CURDIR)/etc/timezone /etc/timezone

# allocate a tty if running interactively
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKERFLAGS += -t
endif

.PHONY: test
test:  ## run all tests
	docker run --rm -i $(DOCKERFLAGS) \
		--name dot-shellcheck \
		-v $(CURDIR):/src:ro \
		shinomineko/shellcheck ./test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
