#!/bin/bash

## `full_text`
case $BLOCK_BUTTON in
  # left click
  1) val=$(zenity --scale --value=$(pamixer --get-volume) --text=Volume) \
      && [[ "$val" -ge 0 ]] && pamixer --set-volume $val && pamixer -u && echo $val% || echo $(pamixer --get-volume)% ;;
  # mousewheel up
  4) pamixer --increase 5 && echo $(pamixer --get-volume)% ;;
  # mousewheel down
  5) pamixer --decrease 5 && echo $(pamixer --get-volume)% ;;
  # right click
  3) pamixer -t && [[ $(pamixer --get-mute) == true ]] && echo "Mute" || echo $(pamixer --get-volume)% ;;
  # any mouse button
  *) [[ $(pamixer --get-mute) == true ]] && echo "Mute" || echo $(pamixer --get-volume)% ;;
esac

vol=$(pamixer --get-volume)

## `short_text`
echo "$vol%"

## `color`
if [[ "$vol" -ge 60 && "$vol" -lt 80 ]]; then
  echo '#FFFF00'
elif [[ "$vol" -ge 80 ]]; then
  echo '#FF0000'
fi

exit 0
