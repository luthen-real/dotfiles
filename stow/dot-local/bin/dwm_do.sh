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
SEL=$(cat $DFILE | cut -d , -f1 | dmenu -l 50)
CMD=$(grep -E "^$SEL" $DFILE | cut -d , -f2)
ARGS=$(grep -E "^$SEL" $DFILE | cut -d , -f3-)
zsh -c "$CMD"
