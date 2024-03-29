
# FISH SHELL SCRIPT


## FUNCTIONS

###
# Find other hosts in the same LAN.
##
function lan_buddies
  sudo arp-scan --interface=eth0 --localnet
end


###
# Clean up package manager chached files and unnecessary packages.
##
function clean
  if type -q pacman
    sudo pacman -Rsn (sudo pacman -Qdtq); sudo pacman --noconfirm -Scc;
  else if type -q apt
    sudo apt clean; sudo apt autoremove; sudo apt autoclean
  else if type -q dnf
    sudo dnf autoremove; sudo dnf clean packages
  else
    echo 'Package manager not supported'
  end
end


###
# Check whether a file exists or not
#
# $argv[1] string file path
##
function file_exists
  if [ ! $argv[1] ]
    echo "Pass file paath as the first argument."
    return 1
  end

  if [ ! -f $argv[1] ]
    echo "File not found: $argv[1]"
    return 1
  end

  return 0
end

###
# Batch change extension of files.
##
function change_extension

  if not test -z $argv[1] ; and begin test $argv[1] = '-h' ; or test $argv[1] = '--help'; end
    echo 'Usages: change_extension SOURCE_EXT DEST_EXT [LOCATION]'
    echo '' ; echo 'Batch change extension of files.'
    return
  end

  if test -z $argv[1] ; or test -z $argv[2]
    echo 'change_extension: missing required argument(s)'
    echo "Try 'change_extension --help' for more information."
    return 1
  end

  if [ $argv[3] ]
    set location $argv[3]
  else
    set location (pwd)
  end

  set src_ext $argv[1]
  set dest_ext $argv[2]

  for file in $location/*.$src_ext
    set file_name (basename $file .$src_ext)
    if test -f $file_name.$dest_ext
      set_color yellow; echo "Destination file already exists: '$file_name.$dest_ext'"; set_color normal
    else
      mv $file_name.$src_ext $file_name.$dest_ext ; and echo "'$file_name.$src_ext' => '$file_name.$dest_ext'"
    end
  end
end

###
# Powersave
#
# USE WITH CAUTION!
##
function powersave
  if not test -z $argv[1]; and test $argv[1] = 'off'
    set cpumaxmhz (lscpu | grep 'CPU max MHz' | awk '{print $4}' | grep -o '[0-9]\+' | head -n1)MHz
    sudo cpupower frequency-set -u "$cpumaxmhz" && echo "Frequency set to $cpumaxmhz"
  else
    set cpuminmhz 1000MHz
    sudo cpupower frequency-set -u "$cpuminmhz" && echo "Frequency set to $cpuminmhz"
  end
end

###
# Random password
#
# $argv[1] length
##
function randpass
  if [ ! $argv[1] ]
    set passlen 20
  else
    set passlen $argv[1]
  end 

  tr -dc A-Za-z0-9\!\@\#\$\%\^\&\(\)\<\>\.\, </dev/urandom | head -c $passlen; echo ''
end
