#!/bin/bash

## Apps for Arch Linux

## General
sudo pacman -S neofetch htop tmux chrome-gnome-shell flatpak gthumb ntfs-3g exfat-utils mlocate entr time vifm mpv vlc pass jq bat bmon nethogs xsel unrar p7zip lm_sensors fzf fd ripgrep glances asciinema exa ncdu
sudo pacman -S ttf-dejavu ttf-roboto ttf-droid ttf-ubuntu-font-family ttf-croscore ttf-liberation
sudo pacman -S git code filezilla php nodejs npm docker docker-compose gimp
sudo pacman -S chromium firefox libreoffice-fresh

sudo usermod -aG docker $USER

## AUR
cd ~/Downloads && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
cd ~/Downloads && git clone https://aur.archlinux.org/snapd.git && cd snapd && makepkg -si
cd ~/Downloads && git clone https://aur.archlinux.org/anydesk-bin.git && cd anydesk-bin && makepkg -si
cd ~/Downloads && git clone https://aur.archlinux.org/ttf-freebanglafont.git && cd ttf-freebanglafont && makepkg -si


## i3wm
#sudo pacman -S i3 i3lock feh dmenu rofi dunst compton volumeicon network-manager-applet
#sudo pacman -S htop nemo flameshot ranger xsel jq pass zenity cpupower bmon nethogs
#sudo pacman -S tumbler acpi sysstat playerctl ibus pamixer pulseaudio-zeroconf pavucontrol ntfs-3g exfat-utils nemo-preview nemo-fileroller
#sudo pacman -S xfce4-terminal xfce4-clipman xfce4-clipman-plugin xfce4-taskmanager xfce4-settings xfce4-power-manager
#sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings arandr lxappearance
#sudo pacman -S mlocate entr notify-send time
#sudo pacman -S powerline powerline-fonts powerline-vim
