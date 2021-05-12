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
		less \
		libc6-dev \
		locales \
		lsof \
		make \
		mount \
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
}

install_dots() {
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

install_tools() {
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	FZF_OPTS=(--key-bindings --no-completion --no-update-rc --no-zsh --no-fish)
	"$HOME/.fzf/install" "${FZF_OPTS[@]}"

	curl -Lo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	if hash kubectl 2>/dev/null; then      # docker desktop has its own kubectl, but not the latest
		curl -Lo "$HOME/.local/bin/kubectl" --create-dirs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		chmod a+x "$HOME/.local/bin/kubectl"
	else
		apt install -y kubectl --no-install-recommends
	fi

	sudo curl -Lo /usr/local/bin/stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
	sudo chown root:root /usr/local/bin/stern
	sudo chmod a+x /usr/local/bin/stern

	sudo curl -Lo /usr/local/bin/hostess https://github.com/cbednarski/hostess/releases/download/v0.5.2/hostess_linux_amd64
	sudo chown root:root /usr/local/bin/hostess
	sudo chmod a+x /usr/local/bin/hostess
}

usage() {
	echo -e "install.sh\\n\\tinstall my basic ubuntu wsl setup\\n"
	echo "Usage:"
	echo " base  - install base pkgs"
	echo " dots  - install dotfiles"
	echo " tools - install cli tools and plugins"
}

main() {
	local cmd="$1"

	case "$cmd" in
		base)
			check_is_sudo
			setup_sources
			install_base
			;;
		dots)
			install_dots
			;;
		tools)
			install_tools
			;;
		*)
			usage
			;;
	esac
}

main "$@"
