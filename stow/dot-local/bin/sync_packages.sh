#!/bin/sh

# This script installs all packages for my artix setup




packages="~/.config/synch_packages.sh/packages.csv"
package_url="https://raw.githubusercontent.com/zeno-nada/setup/refs/heads/main/install/packages.csv"

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


install_yay() {
    if command yay --version &>/dev/null; then
        echo "yay already installed. Skipping..."
        return 0
    fi
    git clone https://aur.archlinux.org/yay.git ~/repos/yay
    cd ~/repos/yay
    makepkg -si
    cd -
}



if id -u &>/dev/null ;then
    error "You must run this script as root"
fi

# Enable parallel downloads for pacman
sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf


# The arch keyring is the package which contains the GPG keys of trusted package maintainers
echo "Refreshing keyring"
pacman --noconfirm --needed -S curl ca-certificates base-devel git zsh || error "Failed to install required packages"



# Use all cores for compilation
sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

[[ -f "$packages" ]] || curl -L -o "$packages" "$package_url"

# Main installation loop
while IFS=, read -r tag package ; do
    case "$tag" in
    "g")
        url=$package
        dir="${url##*/}"
        git  clone --depth 1 --single-branch --no-tags "$url" /tmp/$dir
        cd /tmp/$dir || return
        make
        make install
        ;;
    "y")
        yay -S
        ;;
    *) sudo pacman --noconfirm --needed -S "$package" ;;
    esac
done < $packages
