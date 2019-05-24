#!/bin/bash

# clickable calendar/date

strdate=$(date '+%Y-%m-%d')

case $BLOCK_BUTTON in
  3) echo "$strdate" && zenity --calendar ;; # right-click
  *) echo "$strdate" ;;
esac
