#!/bin/bash

###  lazy termination or shutdown.

term() {
  unset todo ; unset msg ; unset arg ; unset delay ;
  arg=$1 ;
  rex='^[0-9]+$' ;

  if [[ $2 =~ $rex ]]; then
      delay=$2 ;
  else
    delay=5 ;
  fi

  if [[ -z $arg ]]; then
    msg="Terminating in $delay seconds!..." ;
    todo='sudo shutdown -h now' ;
  elif [[ $arg == x ]]; then
    echo -e "\e[91m Terminating NOW! \e[0m" ;
    sleep 1 && sudo shutdown -h now ;
    return ;
  elif [[ $arg == r ]]; then
    msg="Rebooting in $delay seconds!..." ;
    todo='sudo shutdown -r now' ;
  elif [[ $arg == s ]]; then
    msg="Terminating in $delay seconds!..." ;
    todo='sudo shutdown -h now' ;
  elif [[ $arg == a || $arg == c ]]; then
    sudo shutdown -c ;
    echo -e "\e[92m Termination aborted \e[0m" ;
    return ;
  elif [[ $arg == h || $arg == --help || $arg == ? || $arg == -h ]]; then
    echo "USAGES: " ;
    echo "   term [OPTION] [TIME]" ;
    echo "";
    echo "OPTIONS:" ;
    echo "     [NULL]     Shutdown in 5 seconds" ;
    echo "     s          Shutdown" ;
    echo "     x          Shutdown NOW" ;
    echo "     r          Reboot" ;
    echo "     a|c        Abort shutdown" ;
    echo "     --help     Shows this help message" ;
    echo "" ;
    return ;
  else
    echo "term: Invalid option -- '$1'" ;
    echo "Try 'term --help' for more information." ;
    return ;
  fi

  if [[ $msg && $todo ]]; then
    echo -e "\e[91m $msg \e[0m" ;
    echo -en "\e[93m >>   \e[0m" ;
    for (( i = 0; i < $delay; i++ )); do
      backspaces=$(( ${#i} + 2 )) ; #length of i
      for (( j = 0; j < $backspaces; j++ )); do
        echo -en "\b" ;
      done
      echo -en "\e[93m-> $(( i+1 ))\e[0m" ;
      sleep 1 ;
    done
    echo ;
    sleep 1 ;
    eval $todo ;
  fi

}
