
# FISH SHELL SCRIPT


## .env files
dotenv (dirname $DF_SCRIPTS_ROOT)/.env

## Variables
if [ ! $EDITOR ]
    export EDITOR=vim
end

# Suppresses the fish shell welcome message
set fish_greeting

# Identify the OS
if [ ! $OS_ENV ]
    set OS_ENV (grep -E -o '^ID=(.*)$' /etc/os-release | awk -F "=" '{print $2}')
end

if test $OS_ENV = 'manjaro'; or test $OS_ENV = 'archbang'; or test $OS_ENV = 'antergos'
    set OS_ENV 'arch'
end

# Manually set the OS_ENV variable if above does not work.
#set OS_ENV 'arch'		# Arch Linux or Manjaro.
#set OS_ENV 'ubuntu'	# Ubuntu, elementary OS, etc.
#set OS_ENV 'debian'	# Debian, Kali Linux, etc.

# Validation
if [ ! $OS_ENV ]
    set_color red
    echo "The 'OS_ENV' variable is not defined. Some scripts and commands won't work."
    echo -n "Please check the file: "
    set_color yellow
    echo (status --current-filename)
    set_color normal
end
