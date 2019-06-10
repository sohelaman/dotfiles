
# FOR FISH SHELL ONLY


# Utility functions for web developers

###
# Change dir to Apache web root
##
function www
  cd $www_dir
end


###
# Print/tail Apache access log.
#
# $argv[1] number of lines to show from the log. Optional.
##
function accesslog
  file_exists $access_log_file ; if test $status -ne 0 ; return 1 ; end

  if [ $argv[1] ]
    set_color green; sudo tail -f -n $argv[1] $access_log_file ; set_color normal;
  else
    set_color green; sudo tail $access_log_file; set_color normal;
  end
end


###
# Print/tail Apache error log.
#
# $argv[1] number of lines to show from the log. Optional.
##
function errorlog
  if [ $argv[1] ]
    set_color yellow; sudo tail -f -n $argv[1] $error_log_file ; set_color normal;
  else
    set_color yellow; sudo tail $error_log_file ; set_color normal;
  end
end


###
# Edit the php.ini file
##
function php.ini
  file_exists $php_ini_file ; and sudo $EDITOR $php_ini_file
end


###
# Edit the Apache vhosts file.
#
# $argv[1] string name of the unit vhost conf file. Only for Ubuntu/Debian.
##
function vhosts
  if test $OS_ENV = 'arch'
    file_exists $vhosts_file ; and sudo $EDITOR $vhosts_file
  else if test $OS_ENV = 'debian'; or test $OS_ENV = 'ubuntu'
    if [ $argv[1] ]
      file_exists /etc/apache2/sites-enabled/$argv[1] ; and sudo $EDITOR /etc/apache2/sites-enabled/$argv[1]
    else
      echo "Pass one of the following vhost config as the first argument:"
      sudo ls /etc/apache2/sites-enabled
    end
  else
    echo "This OS is not supported!"
  end
end


###
# Edit the MySQL config file.
##
function my.cnf
  sudo $EDITOR $my_cnf_file
end

###
# Start/stop/restart actions for the Apache daemon.
#
# $argv[1] string action name [start|stop|restart|status]
##
function webaction
  echo -n "BEGIN..."
  if test $OS_ENV = 'arch'
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

###
# Start the Apache web server.
##
function webstart
  webaction start
end

###
# Stop the Apache web server.
##
function webstop
  webaction stop
end

###
# Restart the Apache web server.
##
function webrestart
  webaction restart
end

###
# Status of the Apache web server.
##
function webstatus
  webaction status
end


###
# Dump a MySQL database.
#
# $argv[1] string name of the database
##
function dumpdb
  if [ $argv[1] ]
    set dbfilename (pwd)/$argv[1]_(date "+%Y-%m-%d_%H%M").sql.gz
    mysqldump -u root -p $argv[1] | gzip -9 > $dbfilename ; echo Dumped $argv[1] to $dbfilename;
  end
end
