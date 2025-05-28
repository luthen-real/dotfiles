#!/bin/sh

# Installs all packages listed in ~/.config/synch_packages.sh
#  using the corresponding package manager or git


error() {
    printf "Error: $1\n" >&2; exit 1
}


gitmakeinstall() {
	username="${1##*/}"
	repo="${progname%.git}"
	dir="$user/$repo"
    echo  $dir
    return 0
	sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch \
		--no-tags -q "$1" "$dir" ||
		{
			cd "$dir" || return 1
			sudo -u "$name" git pull --force origin master
		}
	cd "$dir" || exit 1
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return 1
}

# Install yay if not already installed
bootstrap_yay() {
    if command yay --version &>/dev/null; then
        echo "yay already installed. Skipping..."
        return 0
    fi
    mkdir -p ~/repos/yay
    git clone https://aur.archlinux.org/yay.git ~/repos/yay
    cd ~/repos/yay
    makepkg -si
    cd -
}



# The arch keyring is the package which contains the GPG keys of trusted package maintainers
echo "Refreshing keyring and installing required packages"
pacman --noconfirm --needed -S curl ca-certificates base-devel git zsh || error "Failed to install required packages"


# Check if this script is run as root
if id -u &>/dev/null ;then
    error "You must run this script as root"
fi
