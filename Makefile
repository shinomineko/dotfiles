all: sync

sync:
	ln -sfn $(PWD)/zsh/zshrc ~/.zshrc
	ln -sfn $(PWD)/vim/vimrc ~/.vimrc
	ln -sfn $(PWD)/git/gitconfig ~/.gitconfig
	ln -sfn $(PWD)/.editorconfig ~/.editorconfig

	mkdir -p ~/.config/nvim
	ln -sfn $(PWD)/nvim/init.vim ~/.config/nvim/init.vim

	mkdir -p ~/.config/aria2
	ln -sfn $(PWD)/aria2/aria2.conf ~/.config/aria2/aria2.conf

clean:
	rm -f ~/.zshrc
	rm -f ~/.vimrc
	rm -f ~/.gitconfig
	rm -f ~/.editorconfig

	rm -rf ~/.config/nvim
	rm -rf ~/.config/aria2

.PHONY: all clean sync build run kill
