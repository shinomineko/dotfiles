#!/bin/bash
set -eo pipefail

# fedora-wsl.sh
#   fix some stuff because I'm using fedora rootfs from a fedora container

check_is_sudo() {
	if [ "$(id -u)" -ne "0" ]; then
		echo "Please run as root"
		exit 1
	fi
}

main() {
	check_is_sudo

	# make `man` usable again
	sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf
	dnf install -y \
		man-db \
		man-pages

	# create the user
	dnf install -y \
		cracklib-dicts \
		passwd

	useradd -G wheel sc
	passwd sc

	# set the default user for wsl
	cat <<-EOF > /etc/wsl.conf
	[user]
	default=sc
	EOF

	# fix userspace containers
	dnf reinstall -y shadow-utils

	dnf clean all

	echo
	echo "Done. You can now run install.sh"
}

main "$@"
