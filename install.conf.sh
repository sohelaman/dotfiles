#!/bin/bash

# Installer Configuration
## CAUTION! Paths may vary from distro to distro.

# Any commented out line/config will be ignored.

# --------------------------------- <home> ---------------------------------- #
# configuration fileset for `/home` directory
declare -a fileset_home

fileset_home+=(.vimrc)
fileset_home+=(.tmux.conf)
fileset_home+=(.config/compton.conf)
fileset_home+=(.config/dunst/dunstrc)
#fileset_home+=(.config/fish/config.fish)  # better done manually instead.
fileset_home+=(.config/htop/htoprc)
fileset_home+=(.xinitrc)
fileset_home+=(.config/i3/config)
fileset_home+=(.config/i3/i3blocks.conf)
fileset_home+=(.config/mpv/mpv.conf)
#fileset_home+=(.config/polybar/config)
fileset_home+=(.config/ranger/rc.conf)
#fileset_home+=(.config/terminator/config)
fileset_home+=(.config/vlc/vlcrc)
#fileset_home+=(.config/vlc/vlc-qt-interface.conf)  # includes hardcoded username.
fileset_home+=(.config/volumeicon/volumeicon)
fileset_home+=(.config/xfce4/terminal/terminalrc)
# --------------------------------- </home> --------------------------------- #


# --------------------------------- <etc> ----------------------------------- #
# configuration fileset for `/etc` directory
declare -a fileset_etc

fileset_etc+=(X11/xorg.conf.d/20-intel.conf)
fileset_etc+=(X11/xorg.conf.d/70-synaptics.conf)
# --------------------------------- </etc> ---------------------------------- #
