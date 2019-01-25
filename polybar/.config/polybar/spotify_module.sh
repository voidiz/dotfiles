#!/usr/bin/env bash

# $1 is counter 

if (( $1 % 2 == 0 ))
then
    echo 'hidden'
else
    artist=$(sp current | grep -oP "^Artist\s+\K.+$")
    title=$(sp current | grep -oP "^Title\s+\K.+$")
    echo "$artist" - "$title"
fi
