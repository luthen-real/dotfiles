#!/usr/bin/env zsh


# Reads a csv file of alias command "mappings"
# and prompts the user using dmenu.
# It then executes the selected option.

error() {
    echo "error: $1"
    exit 1
}

DFILE=~/.config/$(basename $0)/options.csv
touch $DFILE
SEL=$(cat $DFILE | cut -d , -f1 | sort -ui  | dmenu -p "DO: ")
[[ $SEL == "" ]] && exit 1 # exit if nothing was selected
CMD=$(grep -E "^$SEL" $DFILE | cut -d , -f2)
zsh -c "$CMD"
