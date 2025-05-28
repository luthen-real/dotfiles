#!/usr/bin/env zsh


# script to handle bookmark dmenu helper
# open: query user using dmenu
# save: save to correct file in ~/.config/bookmarks.sh/bookmarks


DATA_FILE=~/.config/bookmarks.sh/bookmarks

if [[ $1 == "open" ]]; then
    xdg-open $(cat $DATA_FILE | dmenu -l 50)
elif [[ $1 == "save" ]]; then
    bookmark=$(xclip -o)
    echo "$bookmark" >> $DATA_FILE
    notify-send "Added bookmark" "Bookmark $bookmark added to file"
else
    echo "usage: bookmark.sh open|save"
fi
