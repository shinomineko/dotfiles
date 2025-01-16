#!/usr/bin/env bash
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
        direnv \
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

install_golang() {
    echo
    echo "Installing golang..."
    echo

    export GO_VERSION
    GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text" | grep -v "time")
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

    _install_go_tools
}

install_tools() {
    echo
    echo "Installing kubectl..."
    echo

    curl -Lo "$HOME/.local/bin/kubectl" "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod a+x "$HOME/.local/bin/kubectl"

    _install_go_tools
}

_install_go_tools() {
    echo
    echo "Installing go cli tools..."
    echo

    if hash go &>/dev/null; then
        go install github.com/mikefarah/yq/v4@latest
        go install sigs.k8s.io/kind@latest
        go install github.com/yannh/kubeconform/cmd/kubeconform@latest
        go install github.com/open-policy-agent/conftest@latest
        go install github.com/google/go-containerregistry/cmd/crane@latest
        go install mvdan.cc/sh/v3/cmd/shfmt@latest
    else
        echo "go is not installed. Skipping..."
    fi
}

usage() {
    echo -e "install.sh\\n\\tInstall my basic ubuntu setup"
    echo "Usage: install.sh <command>"
    echo " base             - install base packages"
    echo " dot              - install dotfiles"
    echo " tools            - install cli tools"
    echo " golang           - install/upgrade golang"
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
