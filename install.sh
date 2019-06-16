#!/bin/bash

# Installer Script


###
# Place configs.
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


## Begin installation

# source installer config
THIS_SCRIPT_PATH=$(dirname `which $0`)
source $THIS_SCRIPT_PATH/install.conf.sh

# process different sets of configurations
src_base_home=$THIS_SCRIPT_PATH/configs/home/sohel  # base for files in this repo.
target_base_home=~
placeConfigurations fileset_home src_base_home target_base_home

src_base_etc=$THIS_SCRIPT_PATH/configs/etc
target_base_etc=/etc
placeConfigurations fileset_etc src_base_etc target_base_etc true

echo 'All done.'
