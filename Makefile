all: sync

sync:
	ln -sfn $(PWD)/bash/bash_profile ~/.bash_profile
	ln -sfn $(PWD)/bash/bashrc ~/.bashrc
	ln -sfn $(PWD)/vim/vimrc ~/.vimrc
	ln -sfn $(PWD)/git/gitconfig ~/.gitconfig
	  
	mkdir -p ~/.config/aria2
	ln -sfn $(PWD)/aria2/aria2.conf ~/.config/aria2/aria2.conf

clean:
	rm -f ~/.bash_profile
	rm -f ~/.bashrc
	rm -f ~/.vimrc
	rm -f ~/.gitconfig
	  
	rm -rf ~/.config/aria2

.PHONY: all clean sync build run kill
