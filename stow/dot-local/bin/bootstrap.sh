#!/bin/sh


# This script installs all packages for my setup

packages="packages.csv"
package_url="https://raw.githubusercontent.com/zeno-nada/setup/refs/heads/main/install/packages.csv"

error() {
    printf "Error: $1\n" >&2; exit 1
}

gitmakeinstall() {
	username="${1##*/}"
	repo="${dir%.git}"
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


if id -u &>/dev/null ;then
    error "You must run this script as root"
fi

# make pacman colorful and the dot a the pacman
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -Ei "s/^#(ParallelDownloads).*/\1 = 5/;/^#Color$/s/#//" /etc/pacman.conf

# The arch linux keyring is the package which contains the GPG keys of trusted package maintainers
echo "Refreshing keyring"
pacman --noconfirm --needed -S  archlinux-keyring ||  error "Could not refresh keyring"
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
        make install;;
    *) sudo pacman --noconfirm --needed -S "$package" ;;
    esac
done < $packages



# ---------------------------------------------------------------------------------
# Create new user


printf "Enter password: "; read -s pw0
printf "\nRetype password: "; read -s pw1
while ! [ "$pw0" = "$pw1" ]; do
    printf "\nPasswords do not match."
    printf "\nEnter password: "; read -s pw0
    printf "\nRetype password: "; read -s pw1
done
echo

useradd -m -G wheel sudo -s /bin/zsh user
echo "user:$pw0" | chpasswd




# ---------------------------------------------------------------------------------
# Create required direcories

USER_HOME=/home/user
mkdir -vp $USER_HOME/projects $USER_HOME/.config $USER_HOME/.shh $USER_HOME


# ---------------------------------------------------------------------------------
# Clone all github repos into ~/projects


repos=(
  "git@github.com:zeno-nada/setup.git"
)

for repo in "${repos[@]}"; do
    git clone $repo $USER_HOME/projects/"${repo##*/}"
done

f=id_ed25519_github
[ -f $USER_HOME/.ssh/$f.pub ] || ssh-keygen -t ed25519 -b 4096 -C "" -f $USER_HOME/.ssh/$f
