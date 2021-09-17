#!/bin/bash
path=$(($RANDOM % 2))
if [ $path -eq 0 ]; then
    output=$(curl -s  -X GET 'https://api.tronalddump.io/random/quote' -H "Accepts:application/json" | jq .value)
    CLEAN=${output//[^a-zA-z0-9 ,.?!\']/}
    echo "Donald trump once said: $CLEAN" | cowsay -f tux | lolcat
else
    output=$(curl -s -X GET "https://api.adviceslip.com/advice" | jq .slip.advice)
    CLEAN=${output//[^a-zA-z0-9 ,.?!\']/}
    echo "Random tip: $CLEAN" | cowsay -f tux | lolcat 
fi
