#!/usr/bin/env zsh



i=0
trap  'echo;echo $(date "+%d.%m"): $i >>| ~/.cache/study-logs.txt; exit' INT TERM 

while [[ $input != "q" ]]; do 
    echo Round $(($i+1))
    timer.sh 55 "Finished session #$((i+1))"
    i=$((i+1))
    printf "input 'q' to quit and write: "
    read input
done

echo $(date +%d.%m) $i >> ~/.cache/study-logs.txt
