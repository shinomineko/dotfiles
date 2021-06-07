#!/bin/bash
set -eo pipefail

check_is_sudo() {
	if [ "$(id -u)" -ne "0" ]; then
		echo "Please run as root"
		exit 1
	fi
}

setup_sources() {
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

	cat <<-EOF > /etc/yum.repos.d/google-chrome.repo
	[google-chrome]
	name=google-chrome
	baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
	enabled=1
	gpgcheck=1
	gpgkey=https://dl.google.com/linux/linux_signing_key.pub
	EOF

	rpm --import https://downloads.1password.com/linux/keys/1password.asc
	cat <<-EOF > /etc/yum.repos.d/1password.repo
	[1password]
	name="1Password Stable Channel"
	baseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey="https://downloads.1password.com/linux/keys/1password.asc"
	EOF

	# RPM fusion
	local fedoraversion
	fedoraversion="$(rpm -E %fedora)"

	dnf install -y \
		https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$fedoraversion".noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$fedoraversion".noarch.rpm
}

install_base() {
	echo
	echo "Installing base packages..."
	echo

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

install_wmapps() {
	echo
	echo "Installing window manager and desktop packages..."
	echo

	sudo dnf upgrade -y
	sudo dnf install -y \
		1password \
		dunst \
		feh \
		google-chrome-stable \
		i3 \
		i3lock \
		i3status \
		maim \
		rofi \
		tilix \
		xclip
}

install_graphics() {
	echo
	echo "Installing graphics drivers..."
	echo

	dnf upgrade -y
	dnf install -y \
		akmod-nvidia \
		xorg-x11-drv-nvidia-cuda
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
	echo "Installing neovim and vim plugins..."
	echo

	# install node, needed for coc.nvim
	sudo dnf module install nodejs:14/default -y

	# also install neovim
	sudo dnf install neovim -y

	curl -Lo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	vim +PlugInstall +PlugClean! +qall
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
		sudo dnf install -y kubectl
	fi

	echo
	echo "Installing kind..."
	echo

	sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64
	sudo chown root:root /usr/local/bin/kind
	sudo chmod a+x /usr/local/bin/kind

	echo
	echo "Installing stern..."
	echo

	sudo curl -Lo /usr/local/bin/stern https://github.com/wercker/stern/releases/latest/download/stern_linux_amd64
	sudo chown root:root /usr/local/bin/stern
	sudo chmod a+x /usr/local/bin/stern

	echo
	echo "Installing hostess..."
	echo

	sudo curl -Lo /usr/local/bin/hostess https://github.com/cbednarski/hostess/releases/latest/download/hostess_linux_amd64
	sudo chown root:root /usr/local/bin/hostess
	sudo chmod a+x /usr/local/bin/hostess
}

install_docker() {
	echo
	echo "Installing docker..."
	echo

	cat <<-EOF > /etc/yum.repos.d/docker.repo
	[docker]
	name=Docker CE Stable
	baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
	enabled=1
	gpgcheck=1
	gpgkey=https://download.docker.com/linux/fedora/gpg
	EOF

	dnf install -y \
		containerd.io \
		docker-ce \
		docker-ce-cli

	systemctl daemon-reload
	systemctl restart docker
	systemctl enable docker
}

usage() {
	echo -e "install.sh\\n\\tInstall my basic fedora setup"
	echo "Usage: install.sh <command>"
	echo " base             - install base packages"
	echo " wm               - install window manager and desktop packages"
	echo " graphics         - install nvidia graphics drivers"
	echo " dot              - install dotfiles"
	echo " vim              - install vim plugins"
	echo " tools            - install cli tools"
	echo " docker           - install docker"
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
		wm)
			install_wmapps
			;;
		graphics)
			check_is_sudo
			install_graphics
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
		docker)
			check_is_sudo
			install_docker
			;;
		*)
			usage
			;;
	esac
}

main "$@"
