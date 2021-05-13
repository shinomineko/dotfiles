#!/bin/bash
set -eo pipefail

export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
	if [ "$(id -u)" -ne "0" ]; then
		echo "Please run as root"
		exit 1
	fi
}

setup_sources() {
	apt update || true
	apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		dirmngr \
		gnupg2 \
		lsb-release \
		--no-install-recommends

	curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

	curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

	# turn off translations
	mkdir -p /etc/apt/apt.conf.d
	echo 'Acquire::Languages "none";' | tee /etc/apt/apt.conf.d/99translations
}

install_base() {
	apt update || true
	apt upgrade -y

	apt install -y \
		adduser \
		automake \
		bash-completion \
		bc \
		bzip2 \
		ca-certificates \
		coreutils \
		curl \
		dnsutils \
		file \
		findutils \
		gcc \
		git \
		gnupg \
		gnupg2 \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		kubectl \
		less \
		libc6-dev \
		locales \
		lsof \
		make \
		mount \
		neovim \
		net-tools \
		pinentry-curses \
		policykit-1 \
		ripgrep \
		ssh \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		unzip \
		vim \
		xz-utils \
		zip \
		--no-install-recommends

	apt autoremove -y
	apt autoclean -y
	apt clean -y

	curl -Lo /usr/local/bin/stern https://github.com/wercker/stern/releases/latest/download/stern_linux_amd64
	chown root:root /usr/local/bin/stern
	chmod a+x /usr/local/bin/stern

	curl -Lo /usr/local/bin/hostess https://github.com/cbednarski/hostess/releases/latest/download/hostess_linux_amd64
	chown root:root /usr/local/bin/hostess
	chmod a+x /usr/local/bin/hostess
}

install_dot() {
	# create subshell
	(
	cd "$HOME"

	if [[ ! -d "$HOME/.dotfiles" ]]; then
		git clone https://github.com/shinomineko/dotfiles.git "$HOME/.dotfiles"
	fi

	cd "$HOME/.dotfiles"
	git remote set-url origin git@github.com:shinomineko/dotfiles.git
	make
	)
}

install_plug() {
	rm -rf "$HOME/.fzf" "$HOME/.fzf.*"
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	FZF_OPTS=(--key-bindings --no-completion --no-update-rc --no-zsh --no-fish)
	"$HOME/.fzf/install" "${FZF_OPTS[@]}"

	curl -Lo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	vim +PlugInstall +PlugClean! +qall

	if hash kubectl 2>/dev/null; then      # docker desktop has its own kubectl, but not the latest
		curl -Lo "$HOME/.local/bin/kubectl" --create-dirs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		chmod a+x "$HOME/.local/bin/kubectl"
	fi

}

usage() {
	echo -e "install.sh\\n\\tinstall my basic ubuntu wsl setup\\n"
	echo "Usage:"
	echo " base  - install base pkgs"
	echo " dot   - install dotfiles"
	echo " plug  - install cli/vim plugins"
}

main() {
	local cmd="$1"

	case "$cmd" in
		base)
			check_is_sudo
			setup_sources
			install_base
			;;
		dot)
			install_dot
			;;
		plug)
			install_plug
			;;
		*)
			usage
			;;
	esac
}

main "$@"
