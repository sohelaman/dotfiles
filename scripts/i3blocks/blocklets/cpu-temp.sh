#!/bin/bash

## collected: https://github.com/jplatte/i3blocks-scripts

temp=$(
    sensors 'coretemp-*' \
        | grep '^Package id' \
        | awk '{ print $4 }' \
        | grep -o '[0-9]\+' \
        | head -n1
)

printf '\uf2c9  %s\u2009°C\n' $temp

if [[ "$temp" -ge 60 && "$temp" -lt 80 ]]; then
    printf '\n#FFFF00'
elif [[ "$temp" -ge 80 ]]; then
    printf '\n#FF0000'
fi
