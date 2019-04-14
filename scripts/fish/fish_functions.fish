
# FOR FISH SHELL ONLY

## FUNCTIONS

function lan_buddies
  sudo arp-scan --interface=eth0 --localnet
end

function www
  cd $www_dir
end

function accesslog
  if [ $argv[1] ]
    set_color green; sudo tail -f -n $argv[1] $access_log_file ; set_color normal;
  else
    set_color green; sudo tail $access_log_file; set_color normal;
  end
end

function errorlog
  if [ $argv[1] ]
    set_color yellow; sudo tail -f -n $argv[1] $error_log_file ; set_color normal;
  else
    set_color yellow; sudo tail $error_log_file ; set_color normal;
  end
end

##  edit php.ini
function php.ini
  sudo $EDITOR $php_ini_file
end

##  edit vhosts
function vhosts
  sudo $EDITOR $vhosts_file
end

##  edit my.cnf
function my.cnf
  sudo $EDITOR $my_cnf_file
end

function webaction
  echo -n "BEGIN..."
  if test $OS_ENV = 'archlinux'
    sudo systemctl $argv[1] httpd mysqld
  else if test $OS_ENV = 'debian'; or test $OS_ENV = 'ubuntu' # checks if debian or ubuntu
    if type -q systemctl # checks if systemd is available
      sudo systemctl $argv[1] apache2 mysql
    else
      sudo service apache2 $argv[1]; and echo -n "Apache OK..."
      sudo service mysql $argv[1]; and echo -n "MySQL OK..."
    end
  else
    echo "This OS is not supported!"
  end
  echo "DONE"
end

function webstart
  webaction start
end

function webstop
  webaction stop
end

function webrestart
  webaction restart
end

function webstatus
  webaction status
end

function dumpdb
  if [ $argv[1] ] # name of the database
    set dbfilename (pwd)/$argv[1]_(date "+%Y-%m-%d_%H%M").sql.gz
    mysqldump -u root -p $argv[1] | gzip -9 > $dbfilename ; echo Dumped $argv[1] to $dbfilename;
  end
end

function clean
  if type -q pacman
    sudo pacman -Rsn (sudo pacman -Qdtq); sudo pacman -Scc;
  else if type -q apt
    sudo apt clean; sudo apt autoremove; sudo apt autoclean;
  else
    echo 'Package manager not supported'
  end
end

