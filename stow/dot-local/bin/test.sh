#!/usr/bin/env zsh






while IFS=, read -r a b c; do
    echo "a: $a"
    echo "b: $b"
    echo "c: $c"
done < input
