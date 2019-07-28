#!/bin/bash

## copy IP to the clipboard on right click

case $BLOCK_BUTTON in
    1) IP=$(curl ifconfig.me/ip) && echo "$IP" ;;
    3) IP=$(curl ifconfig.me/ip) && echo "$IP" && echo "$IP" | xsel -b ;;
    *) exec hostname ;;
esac
