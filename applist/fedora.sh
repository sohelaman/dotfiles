#!/bin/bash

## Apps for Fedora Workstation

## Fastest Mirror
# nano /etc/dnf/dnf.conf and add `fastestmirror=true`

dnf makecache
# dnf search vim
# dnf update
# dnf autoremove
# dnf clean packages
# dnf check-update

## BD Mirrors
dnf config-manager --add-repo http://mirror.amberit.com.bd/fedora/linux/releases/32/Everything/x86_64/os/
dnf config-manager --add-repo http://mirror.xeonbd.com/fedora/linux/releases/32/Everything/x86_64/os/

## RPM Fusion Repo
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## Remi Repo
dnf -y install https://rpms.remirepo.net/fedora/remi-release-32.rpm

## Visual Studio Code Repo
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

## Anydesk Repo
cat >/etc/yum.repos.d/AnyDesk-Fedora.repo <<"EOF"
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/fedora/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF

## Sublime Text Repo
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

## Adobe Flash
#rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
#rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
#dnf install flash-plugin flash-player-ppapi alsa-plugins-pulseaudio libcurl

## Check Repo Updates
dnf check-update

## Common tools and apps
dnf install vim tmux fish
dnf install htop neofetch mlocate entr time vifm pass jq bat bmon nethogs xsel unrar p7zip lm_sensors fzf ripgrep glances asciinema exa ncdu
dnf install gthumb gimp filezilla pulseeffects mpv vlc
dnf install snapd
dnf -y install anydesk sublime-text code

## Docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate \
    docker-logrotate docker-selinux docker-engine-selinux docker-engine
dnf install docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
usermod -aG docker $USER

