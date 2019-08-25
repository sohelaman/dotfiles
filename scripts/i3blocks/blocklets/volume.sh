#!/bin/bash

# clickable volume

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
