SHELL := bash

ifdef DRY_RUN
	LN := echo "would link"
	MKDIR := echo "would create dir"
else
	LN := ln -sfn
	MKDIR := mkdir -p
endif

.PHONY: dot
dot:
	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".github" -not -name ".config" -not -name ".*.swp" -not -name ".gnupg" -type f); do \
		f=$$(basename $$file); \
		$(LN) $$file $(HOME)/$$f; \
	done; \

	@$(LN) $(CURDIR)/gitignore $(HOME)/.gitignore

	@$(MKDIR) $(HOME)/.config
	@for prg in helix ghostty; do \
		$(LN) $(CURDIR)/.config/$$prg $(HOME)/.config/$$prg; \
	done; \

	@$(MKDIR) $(HOME)/.config/fish
	@for file in $(shell find $(CURDIR)/.config/fish -name "*.fish" -type f); do \
		f=$$(basename $$file); \
		$(LN) $$file $(HOME)/.config/fish/$$f; \
	done; \
