SHELL := bash

.PHONY: all
all: sync

.PHONY: sync
sync:
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".github" -not -name ".config" -not -name ".*.swp" -not -name ".gnupg" -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \

	ln -sfn $(CURDIR)/gitignore $(HOME)/.gitignore

	mkdir -p $(HOME)/.config/nvim
	ln -sfn $(CURDIR)/.config/nvim/init.vim $(HOME)/.config/nvim/init.vim

	mkdir -p $(HOME)/.config/aria2
	ln -sfn $(CURDIR)/.config/aria2/aria2.conf $(HOME)/.config/aria2/aria2.conf

	mkdir -p $(HOME)/.ssh/config.d
	ln -sfn $(CURDIR)/etc/ssh/config $(HOME)/.ssh/config

	sudo ln -sfn $(CURDIR)/etc/timezone /etc/timezone

	gpg --list-keys || true;
	mkdir -p $(HOME)/.gnupg
	for file in $(shell find $(CURDIR)/.gnupg -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.gnupg/$$f; \
	done; \

.PHONY: clean
clean:
	for file in .aliases .bash_profile .bash_prompt .bashrc .dockerfunc .exports .functions .path .editorconfig .gitconfig .gitignore .vimrc ; do \
		rm -f $(HOME)/$$file; \
	done; \

	rm -rf $(HOME)/.config/nvim
	rm -rf $(HOME)/.config/aria2

	rm -f $(HOME)/.ssh/config

	sudo rm -f /etc/timezone

	rm -rf $(HOME)/.gnupg/gpg*.conf

# allocate a tty if running interactively
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKERFLAGS += -t
endif

.PHONY: test
test:
	docker run --rm -i $(DOCKERFLAGS) \
		--name dot-shellcheck \
		-v $(CURDIR):/src:ro \
		shinomineko/shellcheck ./test.sh
