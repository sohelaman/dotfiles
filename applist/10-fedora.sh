#!/bin/bash

## Fedora 44

## Apps for Fedora Workstation

dnf check-update
dnf makecache

# dnf search vim
# dnf update
# dnf autoremove
# dnf clean packages

dnf install @development-tools
dnf install @sound-and-video
dnf install langpacks-bn
# dnf install google-noto-sans-bengali-fonts lohit-bengali-fonts

## Common tools and apps
dnf install vim tmux fish unrar p7zip wget fastfetch
dnf install htop nvtop bmon nethogs iotop lm_sensors
dnf install busybox entr time vifm pass jq bat eza xsel fzf ripgrep glances asciinema ncdu
dnf install xbindkeys xdotool
dnf install gthumb gimp filezilla mpv vlc shotcut
dnf install podman distrobox
dnf install bottles virtualbox
dnf install httpd nginx
dnf php php-cli php-fpm php-mysqli
dnf install lua python3-pip golang
dnf install java-latest-openjdk-devel.x86_64 temurin-8-jdk.x86_64
dnf install dotnet-sdk-10.0
# dnf install snapd
# dnf install pulseeffects

## Sublime Text and VSCode. REQUIRES repo
dnf install sublime-text code --setopt=minrate=1

## Media Codecs
dnf install libavcodec-freeworld --allowerasing
dnf swap ffmpeg-free ffmpeg --allowerasing
dnf install intel-media-driver
dnf install libva-nvidia-driver libva-utils

## Docker
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
sudo usermod -aG docker $USER ## @TODO RUN AS NON-ROOT USER
## @TODO LOGOUT AND LOG BACK IN
