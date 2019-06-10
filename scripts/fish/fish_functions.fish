
# FOR FISH SHELL ONLY


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
    sudo pacman -Rsn (sudo pacman -Qdtq); sudo pacman -Scc;
  else if type -q apt
    sudo apt clean; sudo apt autoremove; sudo apt autoclean;
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
    echo "File not found: $argv[1]"
    return 1
  end

  if [ ! -f $argv[1] ]
    echo "File not found: $argv[1]"
    return 1
  end

  return 0
end
