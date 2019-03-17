#!/bin/bash

## copy IP to the clipboard on right click

myterm=xfce4-terminal

case $BLOCK_BUTTON in
    #3) echo "$IP" | xclip ;;
    2) exec whoami ;;
    #2) thepid=$(xprop _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //') && echo "kill $thepid" && kill $thepid ;;
    4) echo "taskmgr" && xfce4-taskmanager ;;
    # 4) echo "htop" && exec $myterm -e htop ;;
    5) echo "files" && $myterm -e ranger ;;
    3) IP=$(curl ifconfig.me/ip) && echo "$IP" && echo "$IP" | xsel -b ;;
    *) exec hostname ;;
esac
