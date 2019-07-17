
# FISH SHELL SCRIPT


## .env files
# dotenv ~/.env
dotenv (dirname $DF_SCRIPTS_ROOT)/.env

## Variables

export EDITOR=vim
set fish_greeting ""  # Suppresses the welcome message

# Identify the OS
set OS_ENV (grep -E -o '^ID=(.*)$' /etc/os-release | awk -F "=" '{print $2}')

# Manually set the OS_ENV variable if above does not work.
#set OS_ENV 'arch'  # Arch Linux or Manjaro.
#set OS_ENV 'ubuntu'  # Ubuntu, elementary OS, etc.
#set OS_ENV 'debian'  # Debian, Kali Linux, etc.

# Validation
if [ ! $OS_ENV ]
  set_color red
	echo "The 'OS_ENV' variable is not defined. Some scripts and commands won't work."
  echo -n "Please check the file: "
  set_color yellow
  echo (status --current-filename)
	set_color normal
end
