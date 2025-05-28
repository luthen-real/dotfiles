#!/bin/sh

# Uses yay to install all packages listed in ~/.config/.../packages.txt
# TODO: implement management packages installed natively using git/makepkg 


error() {
    printf "Error: $1\n" >&2; exit 1
}


# TODO: generalize
gitmakeinstall() {
    reponame="${1##*/}"
    reponame="${reponame%.git}"
    echo $reponame
    return 0

	git clone --depth 1 --single-branch \
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



# The arch keyring is the package which contains the GPG keys of trusted package maintainers
echo "Refreshing keyring and installing required packages"
sudo pacman --noconfirm --needed -S curl ca-certificates base-devel git zsh || error "Failed to install required packages"


# YAY BOOTSTRAP CHECK 
# Check if yay is already installed, if not, clone the repo and install it
if ! command yay --version &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git ~/repos/yay || error "failed to clone yay"
    cd ~/repos/yay
    makepkg -si
    cd -
fi

# Main loop
for package in $(cat ~/.config/$(basename $0)/packages.txt); do
    yay -S --noconfirm --needed $package
done
