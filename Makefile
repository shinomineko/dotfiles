.PHONY: all
all: sync

.PHONY: sync
sync:
	ln -sfn $(PWD)/.zshrc ~/.zshrc
	ln -sfn $(PWD)/.vimrc ~/.vimrc
	ln -sfn $(PWD)/.gitconfig ~/.gitconfig
	ln -sfn $(PWD)/.gitignore ~/.gitignore
	ln -sfn $(PWD)/.editorconfig ~/.editorconfig
	ln -sfn $(PWD)/.dockerfunc ~/.dockerfunc

	mkdir -p ~/.config/nvim
	ln -sfn $(PWD)/.config/nvim/init.vim ~/.config/nvim/init.vim

	mkdir -p ~/.config/aria2
	ln -sfn $(PWD)/.config/aria2/aria2.conf ~/.config/aria2/aria2.conf

	mkdir -p ~/.gnupg
	ln -sfn $(PWD)/.gnupg/gpg.conf ~/.gnupg/gpg.conf
	ln -sfn $(PWD)/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

.PHONY: clean
clean:
	rm -f ~/.zshrc
	rm -f ~/.vimrc
	rm -f ~/.gitconfig
	rm -f ~/.editorconfig
	rm -f ~/.dockerfunc

	rm -rf ~/.config/nvim
	rm -rf ~/.config/aria2

	rm -rf ~/.gnupg/gpg*.conf

