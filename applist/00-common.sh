#!/bin/bash

## Misc software and scripts

## SSH key
chown -R sohel:sohel ~/.ssh && chmod 744 ~/.ssh && chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

## Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo "Installed vim-plug for Vim."

## Vim sublimemonokai theme
curl -fLo ~/.vim/colors/sublimemonokai.vim --create-dirs https://raw.githubusercontent.com/Tiriel/sublimemonokai/master/colors/sublimemonokai.vim && echo "Installed sublimemonokai theme for Vim."

## Install oh-my-fish
#curl -L https://get.oh-my.fish | fish
