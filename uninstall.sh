#!/bin/bash

###  lazy do so uninstall

# exit if fails

echo 'Uninstalling Lazy Scripts...' ;
if [ -d "$HOME/lazy_do_so" ]; then
  rm -rf $HOME/lazy_do_so && echo "Removed $HOME/lazy_do_so/" ;
fi

if grep -q 'source ~/lazy_do_so/lazycomm.sh' "$HOME/.bashrc"; then
  sed -i.backup '/lazycomm.sh/d' $HOME/.bashrc && echo "Removed bashrc entry." ;
fi

if [ -f $HOME/.zshrc ]; then
  if grep -q 'source ~/lazy_do_so/lazycomm.sh' "$HOME/.zshrc"; then
    sed -i.backup '/lazycomm.sh/d' $HOME/.zshrc && echo "Removed zshrc entry." ;
  fi
fi

echo "DONE!" ;
echo "Please restart terminal." ;

