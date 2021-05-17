#!/bin/bash
set -eo pipefail

export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
	if [ "$(id -u)" -ne "0" ]; then
		echo "Please run as root"
		exit 1
	fi
}

setup_sources_fedora() {
	dnf install -y \
		ca-certificates \
		curl \
		gnupg2

	cat <<-EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	EOF
}

setup_sources_ubuntu() {
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

	# turn off translations
	mkdir -p /etc/apt/apt.conf.d
	echo 'Acquire::Languages "none";' | tee /etc/apt/apt.conf.d/99translations
}

install_base_ubuntu() {
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

install_base_fedora() {
	dnf upgrade -y

	dnf install -y \
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
		glibc-all-langpacks \
		gnupg2 \
		grep \
		gzip \
		hostname \
		htop \
		indent \
		iproute \
		iptables \
		iputils \
		jq \
		langpacks-en \
		less \
		lsof \
		make \
		ncurses \
		net-tools \
		openssh-clients \
		pinentry-curses \
		procps-ng \
		ripgrep \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		unzip \
		vim \
		xz \
		zip

	dnf autoremove -y
	dnf clean all
}

install_dot() {
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
	curl -Lo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	vim +PlugInstall +PlugClean! +qall
}

install_golang() {
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

install_tools() {
	rm -rf "$HOME/.fzf" "$HOME/.fzf.*"
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	FZF_OPTS=(--key-bindings --no-completion --no-update-rc --no-zsh --no-fish)
	"$HOME/.fzf/install" "${FZF_OPTS[@]}"

	if [[ -h /usr/local/bin/kubectl ]]; then      # docker desktop has its own kubectl, but not the latest
		curl -Lo "$HOME/.local/bin/kubectl" --create-dirs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		chmod a+x "$HOME/.local/bin/kubectl"
	else
		local distro
		distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release)

		case "$distro" in
			fedora)
				sudo dnf install -y kubectl
				;;
			ubuntu|debian)
				sudo apt update || true
				sudo apt install -y kubectl --no-install-recommends
				;;
		esac
	fi

	sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64
	sudo chown root:root /usr/local/bin/kind
	sudo chmod a+x /usr/local/bin/kind

	sudo curl -Lo /usr/local/bin/stern https://github.com/wercker/stern/releases/latest/download/stern_linux_amd64
	sudo chown root:root /usr/local/bin/stern
	sudo chmod a+x /usr/local/bin/stern

	sudo curl -Lo /usr/local/bin/hostess https://github.com/cbednarski/hostess/releases/latest/download/hostess_linux_amd64
	sudo chown root:root /usr/local/bin/hostess
	sudo chmod a+x /usr/local/bin/hostess
}

usage() {
	echo -e "install.sh\\n\\tinstall my basic wsl setup\\n"
	echo "Usage:"
	echo " base             - install base pkgs"
	echo " dot              - install dotfiles"
	echo " vim              - install vim plugins"
	echo " tools            - install cli tools"
	echo " golang           - install golang and pkgs"
}

main() {
	local cmd="$1"
	local distro
	distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release)

	case "$cmd" in
		base)
			check_is_sudo

			case "$distro" in
				fedora)
					setup_sources_fedora
					install_base_fedora
					;;
				ubuntu|debian)
					setup_sources_ubuntu
					install_base_ubuntu
					;;
				*)
					echo "Distro: ${distro} is not supported"
					exit 1
					;;
			esac
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
