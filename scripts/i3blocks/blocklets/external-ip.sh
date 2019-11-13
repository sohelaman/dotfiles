#!/bin/bash

## copy IP to the clipboard on right click

case $BLOCK_BUTTON in
    1) IP=$(curl ifconfig.me/ip) && echo "$IP" || echo 'N/A' ;;
    3) IP=$(curl ifconfig.me/ip) && echo "$IP" && echo "$IP" | xsel -b || echo 'N/A' ;;
    *) exec hostname -i | awk '{print $1}' ;;
esac

exit 0
