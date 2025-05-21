#!/bin/bash

# This is a simple backup script which saves the specified directories
# on an encrypted disk
# It automatically encrypt and mounts the the usb


MOUNTPOINT=/mnt/usb

# Relative from home dir
directories=(
    dotfiles
    zettelkasten
    resources
    school
    projects
    repos
    audio
    documents
)

if [[ "$(id -u)" -eq 0 ]];then
    echo "Cannot run script as root!"
    exit 1
fi

# Report the status for the mapping
function decrypt_and_mount(){
    if [[ $(sudo cryptsetup status backup) ]]; then
        sudo cryptsetup open --type luks /dev/sda backup
    fi

    if ! mountpoint $MOUNTPOINT; then
        sudo mount /dev/mapper/backup $MOUNTPOINT
    fi
}
function encrypt_and_umount() {
    sudo umount /dev/mapper/backup || echo could not umount
    sudo cryptsetup close backup || echo could not close
}


# notify if there is no usb attached
if [[ ! $(lsblk | grep -E "sd[ab]") ]]; then
    echo "No usb attached"
    exit 1
fi


if [[ $1 == "backup" ]]; then
    decrypt_and_mount
    echo "---------------------------------------------------"
    for dir in "${directories[@]}"; do
        echo "Synching $HOME/$dir to $MOUNTPOINT/backup"
        # Deletes extraneous files and forces deletetion of non-empy dirs
        # Specify root user as owner
        sudo rsync -avh --delete --force --perms --chown=root:root  $HOME/$dir $MOUNTPOINT/backup
        echo "---------------------------------------------------"
    done
    encrypt_and_umount
elif [[ $1 == "restore" ]]; then
    decrypt_and_mount
    echo "---------------------------------------------------"
    for dir in "${directories[@]}"; do
        echo "Synching $MOUNTPOINT/backup/$dir to $HOME/$dir"
        # Deletes extraneous files and forces deletetion of non-empy dirs
        sudo rsync -avh --delete --force --perms --chown=$USER:$USER  $MOUNTPOINT/backup/$dir $HOME/$dir
        echo "---------------------------------------------------"
    done
    encrypt_and_umount
else 
    echo "No task specified. Use either backup/restore"
    exit 1
fi

notify-send -u normal "INFO" "Finished $1"
