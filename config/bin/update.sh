#!/usr/bin/env zsh

echo ":: Checking Arch Linux PGP Keyring..."
local installedver="$(LANG= sudo pacman -Qi archlinux-keyring | grep -Po '(?<=Version         : ).*')"
local currentver="$(LANG= sudo pacman -Si archlinux-keyring | grep -Po '(?<=Version         : ).*')"
if [ $installedver != $currentver ]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -Sy --needed --noconfirm archlinux-keyring
else
    echo " Arch Linux PGP Keyring is up to date."
    echo " Proceeding with full system upgrade."
fi
if (( $+commands[yay] )); then
    yay -Syu
elif (( $+commands[trizen] )); then
    trizen -Syu
elif (( $+commands[pacaur] )); then
    pacaur -Syu
elif (( $+commands[aura] )); then
    sudo aura -Syu
else
    sudo pacman -Syu
fi
