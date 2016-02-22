#!/bin/bash

###  lazy common shortcuts

##  cow says fortune
fortunecookie() {
  if [[ fortune && cowsay ]]; then
    fortune | cowsay ;
    echo ;
  else
    sudo apt-get install -y fortune cowsay ;
    echo 'Hello' | cowsay ;
  fi
}

##  yells what you say
yell() { echo $1 | tr '[:lower:]' '[:upper:]' ; }

##  edit apt source file
src() {
	sudo $editor /etc/apt/sources.list ;
}

##  cleans apt-cache and unnecessary packages
clean() {
	sudo apt-get autoremove ;
	sudo apt-get autoclean ;
	sudo apt-get clean ;
}

weather() {
  if [[ -z $1 ]]; then
    curl -4 'http://wttr.in/Dhaka'
  else
    curl -4 'http://wttr.in/'$1
  fi
}
