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
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		lsb-release \
		--no-install-recommends

	curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

	# turn off translations
	mkdir -p /etc/apt/apt.conf.d
	echo 'Acquire::Languages "none";' | tee /etc/apt/apt.conf.d/99translations
}

install_base() {
	echo
	echo "Installing base packages..."
	echo

	apt-get update || true
	apt-get upgrade -y

	apt-get install -y \
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
		htop \
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
		shellcheck \
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

	apt-get autoremove -y
	apt-get autoclean -y
	apt-get clean -y
}

install_dot() {
	echo
	echo "Installing dotfiles..."
	echo

	# subshell
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

install_vim() {
	echo
	echo "Installing vim stuff..."
	echo

	# install node, needed for coc.nvim
	curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
	VERSION=node_14.x
	DISTRO="$(lsb_release -s -c)"
	echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

	sudo apt-get update || true
	sudo apt-get install -y \
		nodejs \
		--no-install-recommends

	curl -Lo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	vim +PlugInstall +PlugClean! +qall

	# update alternatives to vim
	sudo update-alternatives --install /usr/bin/vi vi "$(command -v vim)" 60
	sudo update-alternatives --config vi
	sudo update-alternatives --install /usr/bin/editor editor "$(command -v vim)" 60
	sudo update-alternatives --config editor
}

install_golang() {
	echo
	echo "Installing golang and packages..."
	echo

	export GO_VERSION
	GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
	export GO_SRC=/usr/local/go

	if [[ -n "$1" ]]; then
		GO_VERSION="$1"
	fi

	if [[ -d "$GO_SRC" ]]; then
		sudo rm -rf "$GO_SRC"
		sudo rm -rf "$GOPATH"
	fi

	GO_VERSION=${GO_VERSION#go}

	(
	kernel=$(uname -s | tr '[:upper:]' '[:lower:]')
	curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.${kernel}-amd64.tar.gz" | sudo tar -zxv -C /usr/local
	)

	(
	set -x
	set +e

	go get golang.org/x/lint/golint
	go get golang.org/x/tools/cmd/cover
	go get golang.org/x/tools/gopls
	go get golang.org/x/review/git-codereview
	go get golang.org/x/tools/cmd/goimports
	go get golang.org/x/tools/cmd/gorename
	go get golang.org/x/tools/cmd/guru
	go get github.com/axw/gocov/gocov
	go get github.com/jstemmer/gotags
	go get github.com/nsf/gocode
	go get github.com/rogpeppe/godef
	go get honnef.co/go/tools/cmd/staticcheck
	)
}

_install_tool() {
	local tool="$1"
	local url="$2"

	echo
	echo "Installing ${tool}..."
	echo

	sudo curl -Lo "/usr/local/bin/${tool}" "$url"
	sudo chown root:root "/usr/local/bin/${tool}"
	sudo chmod a+x "/usr/local/bin/${tool}"
}

install_tools() {
	echo
	echo "Installing fzf..."
	echo

	rm -rf "$HOME/.fzf" "$HOME/.fzf.*"
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	FZF_OPTS=(--key-bindings --no-completion --no-update-rc --no-zsh --no-fish)
	"$HOME/.fzf/install" "${FZF_OPTS[@]}"

	echo
	echo "Installing kubectl..."
	echo

	if [[ -h /usr/local/bin/kubectl ]]; then      # docker desktop has its own kubectl, but not the latest
		curl -Lo "$HOME/.local/bin/kubectl" --create-dirs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		chmod a+x "$HOME/.local/bin/kubectl"
	else
		sudo apt-get update || true
		sudo apt-get install -y kubectl --no-install-recommends
	fi


	_install_tool kind https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64
	_install_tool stern https://github.com/wercker/stern/releases/latest/download/stern_linux_amd64
	_install_tool hostess https://github.com/cbednarski/hostess/releases/latest/download/hostess_linux_amd64
	_install_tool yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
}

usage() {
	echo -e "install.sh\\n\\tInstall my basic ubuntu setup"
	echo "Usage: install.sh <command>"
	echo " base             - install base packages"
	echo " dot              - install dotfiles"
	echo " vim              - install vim plugins"
	echo " tools            - install cli tools"
	echo " golang           - install golang and packages"
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
		vim)
			install_vim
			;;
		golang)
			install_golang "$2"
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
