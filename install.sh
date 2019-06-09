#!/bin/bash

# Installer
## CAUTION! Paths may vary from distro to distro.


# --- Config filesets ---

########################### <home> ######################################
declare -a fileset_home
fileset_home+=(.vimrc)
fileset_home+=(.config/compton.conf)
fileset_home+=(.config/dunst/dunstrc)
#fileset_home+=(.config/fish/config.fish)  # better done manually instead.
fileset_home+=(.config/htop/htoprc)
fileset_home+=(.config/i3/config)
fileset_home+=(.config/i3/i3blocks.conf)
fileset_home+=(.config/mpv/mpv.conf)
#fileset_home+=(.config/polybar/config)
fileset_home+=(.config/ranger/rc.conf)
#fileset_home+=(.config/terminator/config)
fileset_home+=(.config/vlc/vlcrc)
#fileset_home+=(.config/vlc/vlc-qt-interface.conf)  # includes hardcoded username.
fileset_home+=(.config/volumeicon/volumeicon)
########################### </home> #####################################


########################### <etc> #######################################
declare -a fileset_etc
fileset_etc+=(X11/xorg.conf.d/20-intel.conf)
fileset_etc+=(X11/xorg.conf.d/70-synaptics.conf)
########################### </etc> ######################################



# --- Backbone ---


###
# Core function
#
# arg $1 array of file name
# arg $2 source base directory in this repo
# arg $3 target base directory
# arg $4 boolean if sudo is required
##
function placeConfigurations() {
	local -n fileset=$1
	local -n src_base_dir=$2
	local -n target_base_dir=$3
	local -n require_sudo=false

	if [ "$4" = true ] ; then
	  require_sudo=true
	fi

	echo "Processing: $src_base_dir"

	for file in "${fileset[@]}"; do
		src=$(realpath $src_base_dir/$file)
		target=$target_base_dir/$file
		if test -f $target; then
		  if test -h $target; then
			  if [ "$require_sudo" = true ] ; then
			  	sudo unlink $target && echo "UNLINK EXISTING: $target"
				else
					unlink $target && echo "UNLINK EXISTING: $target"
				fi
			else
				if [ "$require_sudo" = true ] ; then
					sudo mv $target $target.backup && echo "MOVE EXISTING: $target => $target.backup"
				else
					mv $target $target.backup && echo "MOVE EXISTING: $target => $target.backup"
				fi
			fi
		else
		  if [ ! -d $(dirname $target) ]; then
		    if [ "$require_sudo" = true ] ; then
		    	sudo mkdir -p $(dirname $target) && echo "MKDIR: $(dirname $target)"
				else
		    	mkdir -p $(dirname $target) && echo "MKDIR: $(dirname $target)"
				fi
			fi
		fi

		if [ "$require_sudo" = true ] ; then
			sudo ln -s $src $target && echo "SUCCESS: $target"
		else
			ln -s $src $target && echo "SUCCESS: $target"
		fi

	done  # endfor

	echo "---"
}  # end of placeConfigurations()


# process different sets of configurations
src_base_home=./configs/home/sohel  # base for files in this repo.
target_base_home=~
placeConfigurations fileset_home src_base_home target_base_home

src_base_etc=./configs/etc
target_base_etc=/etc
placeConfigurations fileset_etc src_base_etc target_base_etc true
