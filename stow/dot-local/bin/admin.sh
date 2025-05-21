#!/usr/bin/env zsh


PROMPT3="select> "

select option in "shutdown" "upgrage yay packages" "upgrage yay packages" "list it";
do
    if [[ ! $option  ]]; then
        echo done
        exit 1
    fi
    echo $option
done


