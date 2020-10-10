#!/bin/bash

## Misc software and scripts

## SSH key
chown -R sohel:sohel ~/.ssh && chmod 744 ~/.ssh && chmod 600 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

## Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo "Installed vim-plug for Vim."

## Vim sublimemonokai theme
curl -fLo ~/.vim/colors/sublimemonokai.vim --create-dirs https://raw.githubusercontent.com/Tiriel/sublimemonokai/master/colors/sublimemonokai.vim && echo "Installed sublimemonokai theme for Vim."

## Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

## Install oh-my-fish
#curl -L https://get.oh-my.fish | fish

## Install fisher
#curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
