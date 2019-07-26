#!/bin/bash

# clickable calendar/date

strdate=$(date '+%Y-%m-%d')
today="Today: $(date '+%A, %B %d, %Y')"

case $BLOCK_BUTTON in
  # left click
  1) echo "$strdate" && date '+%Y-%m-%d_%H-%M-%S' | tr -d '\n' | xsel -b;;
  # middle click
  2) echo "$strdate" && date '+%Y-%m-%d %H:%M:%S' | tr -d '\n' | xsel -b ;;
  # mousewheel up
  4) echo "$strdate" && date '+%Y-%m-%d_%H%M%S' | tr -d '\n' | xsel -b ;;
  # mousewheel down
  5) echo "$strdate" && date '+%Y-%m-%d_%H%M%S' | tr -d '\n' | xsel -b ;;
  # right click
  3) echo "$strdate" && zenity --calendar --date-format=%Y-%m-%d --text="$today" | tr -d '\n' | xsel -b ;;
  # any mouse button
  *) echo "$strdate" ;;
esac
