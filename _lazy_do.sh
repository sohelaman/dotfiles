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

record() {
  if [[ -z $1 ]]; then
    arecord -f cd ~/Music/record_$(date +%Y%m%d_%H%M%S).wav
  else
    arecord -f cd $(pwd)/$1.wav
  fi
}

screengif() {
  if [[ byzanz-record ]]; then
    width=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
    height=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
    byzanz-record --cursor --duration=$1 --x=0 --y=0 --width=$width --height=$height $2.gif
  else
    sudo apt-get install -y byzanz ;
    echo 'Installed Byzanz' ;
  fi
}

get() {
  if [[ -z $1 ]]; then
    sudo apt-get update
  else
    sudo apt-get install $1
  fi
}
