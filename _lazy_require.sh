#!/bin/bash

##  find editor
if which /opt/sublime_text/sublime_text > /dev/null ; then
  editor=/opt/sublime_text/sublime_text ;
elif which gedit > /dev/null ; then
  editor=gedit ;
elif which vim > /dev/null ; then
  editor=vim ;
else
  editor=nano ;
fi

##  explicit editor setup
# editor=nano ;

##  formatted style variables
f_normal="\e[0m" ; 	# resets all
f_default="\e[39m" ;	# reset fg color
f_bold="\e[1m" ;
f_underlined="\e[4m" ;
f_inverted="\e[7m" ;

f_red="\e[91m" ;
f_blue="\e[34m" ;
f_magenta="\e[95m" ;
f_green="\e[92m" ;
f_yellow="\e[93m" ;
f_white="\e[97m" ;
f_black="\e[30m" ;
f_gray="\e[90m" ;
f_cyan="\e[96m" ;

f_red_bg="\e[101m" ;
f_green_bg="\e[42m" ;
f_blue_bg="\e[104m" ;
f_gray_bg="\e[100m" ;
f_cyan_bg="\e[106m" ;
f_white_bg="\e[107m" ;
f_yellow_bg="\e[103m" ;
f_magenta_bg="\e[105m" ;

