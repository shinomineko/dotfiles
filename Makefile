SHELL := bash

.PHONY: dot
dot:
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
