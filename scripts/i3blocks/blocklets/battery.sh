#!/bin/bash

battpc=$(acpi -b | awk '{print $4}' | sed 's/,//g')
battstat=$(acpi -b | awk '{print $3}' | sed 's/,//g')

case $BLOCK_BUTTON in
  # left click
  1) echo "$battpc $battstat" && zenity --info --text="$(acpi -b)" --icon-name=battery --no-wrap ;;
  # any
  *) echo "$battpc $battstat" ;;
esac

## `short_text`
echo "$battpc $battstat"

## `color`
if [[ "$battstat" = "Discharging" && ${battpc%?} -le 10 ]]; then
  echo "#FF0000"
  exit 33 ## send urgent flag
elif [[ "$battstat" = "Discharging" && ${battpc%?} -lt 30 ]]; then 
  echo "#FF0000"
elif [[ "$battstat" = "Discharging" ]]; then 
  echo "#FF8000"
elif [[ "$battstat" = "Charging" ]]; then 
  echo "#00FFFF"
fi

exit 0
