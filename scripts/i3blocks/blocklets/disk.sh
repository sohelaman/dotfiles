#!/bin/bash

diskusage=$(df -h / | grep '\/$' | awk '{print $5" "$4}')

## `full_text`
case $BLOCK_BUTTON in
  # left click
  1) echo ": $diskusage" && zenity --info --text="<span font='monospace'>$(df -h | grep 'Use\%\|/dev/sd')</span>" --no-wrap ;;
  # any mouse button
  *) echo ": $diskusage" ;;
esac

diskusagepc=$(df -h / | grep '\/$' | awk '{print $5}')

## `short_text`
echo ": $diskusagepc"

## `color`
if [[ ${diskusagepc%?} -ge 75 && ${diskusagepc%?} -lt 90 ]]; then
  echo "#FF8000"
elif [[ ${diskusagepc%?} -ge 90 ]]; then
  echo "#FF0000"
  ## `background`
  exit 33 ## send urgent flag
fi

exit 0
