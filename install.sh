#!/bin/bash

###  lazy do so install

# exit if fails
set -e

echo 'Installing Lazy Scripts...' ;
if [ -d "$HOME/lazy_do_so" ]; then
  mv -f $HOME/lazy_do_so $HOME/lazy_do_so_backup && echo "Backup created $HOME/lazy_do_so_backup/" ;
fi

mkdir $HOME/lazy_do_so && echo "Created directory $HOME/lazy_do_so/" ;
cp * $HOME/lazy_do_so/ && echo "Copied scripts to $HOME/lazy_do_so/" ;

append_text="source ~/lazy_do_so/lazycomm.sh" ;

if grep -q 'source ~/lazy_do_so/lazycomm.sh' "$HOME/.bashrc"; then
  echo "Found previous bashrc entry." ;
  sed -i.backup '/lazycomm.sh/d' $HOME/.bashrc ;
  echo $append_text >> $HOME/.bashrc ;
else
  echo $append_text >> $HOME/.bashrc  && echo "Added bashrc entry." ;
fi

if [ -f $HOME/.zshrc ]; then
    if grep -q 'source ~/lazy_do_so/lazycomm.sh' "$HOME/.zshrc"; then
      echo "Found previous zshrc entry." ;
      sed -i.backup '/lazycomm.sh/d' $HOME/.zshrc ;
      echo $append_text >> $HOME/.zshrc ;
    else
      echo $append_text >> $HOME/.zshrc && echo "Added zshrc entry." ;
    fi
fi

echo "DONE!" ;
echo "Please restart terminal." ;
