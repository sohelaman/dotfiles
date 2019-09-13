#!/bin/bash

temp=$(sensors 'coretemp-*' \
    | grep '^Package id' \
    | awk '{ print $4 }' \
    | grep -o '[0-9]\+' \
    | head -n1)

## 1st line `full_text`
printf '\uf2c9  %s\u2009°C\n' $temp

## 2nd line `short_text`
echo "$temp °C"

if [[ "$temp" -ge 60 && "$temp" -lt 80 ]]; then
  ## 3rd line `color`
  echo '#FFFF00'
elif [[ "$temp" -ge 80 ]]; then
  ## 3rd line `color`
  echo '#FF0000'
  ## 4th line `background`
  # exit 33
fi

exit 0
