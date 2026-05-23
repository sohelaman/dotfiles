#!/bin/bash

## Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.onlyoffice.desktopeditors
flatpak install flathub com.spotify.Client
flatpak install flathub org.telegram.desktop
flatpak install flathub com.getpostman.Postman
flatpak install flathub io.dbeaver.DBeaverCommunity
flatpak install flathub org.kde.kdenlive
flatpak install flathub us.zoom.Zoom
flatpak install flathub com.obsproject.Studio
flatpak install flathub org.kde.krita
flatpak install flathub com.brave.Browser


## Snap
systemctl status snapd

sudo snap install powershell --classic
sudo snap install vivaldi
