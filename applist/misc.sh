#!/bin/bash

## Misc software and scripts

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && echo "Installed vim-plug for Vim."

# Vim sublimemonokai theme
curl -fLo ~/.vim/colors/sublimemonokai.vim --create-dirs https://raw.githubusercontent.com/Tiriel/sublimemonokai/master/colors/sublimemonokai.vim && echo "Installed sublimemonokai theme for Vim."

# Install oh-my-fish
curl -L https://get.oh-my.fish | fish
