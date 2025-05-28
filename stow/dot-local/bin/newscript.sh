#!/bin/sh

filename=$(gum input --placeholder 'name' --no-show-help)

while [ -f $filename ]; do
    printf "'$filename' exists!\n"
    filename=$(gum input --placeholder 'Enter other name' --no-show-help)
done


cat ~/.config/newscript.sh/$(gum choose zsh bash python) >> $filename
mkdir -vp ~/.config/$filename
chmod +x $filename

echo "$(basename $0): created file '$filename'"
