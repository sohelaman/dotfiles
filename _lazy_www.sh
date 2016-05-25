#!/bin/bash

###  lazy shortcuts for web developers

##  find distro
if [[ $(lsb_release -d | grep Ubuntu) ]]; then
  wwwdir=/var/www ;
elif [[ $(lsb_release -d | grep Debian) ]]; then
  wwwdir=/var/www/html ;
else
  wwwdir=/var/www ;
fi

##  cd to localhost www directory
www() {
  if [[ -z $1 ]]; then
    cd $wwwdir ;
    return ;
  else
    if [[ -d $wwwdir/$1 ]]; then
      cd $wwwdir/$1 ;
    else
      echo "'$1' not found" ;
    fi
  fi
}

##  start apache and mysql services
webstart() {
  echo -n "Starting services..." ;
	sudo service apache2 start && echo -n "Apache started..." ;
	sudo service mysql start && echo -n "MySQL started..." ;
  echo "DONE!" ;
}

##  stop apache and mysql services
webstop() {
  echo -n "Stopping services..." ;
	sudo service apache2 stop && echo -n "Apache stopped..." ;
	sudo service mysql stop && echo -n "MySQL stopped..." ;
  echo "DONE!" ;
}

##  restart apache and mysql services
webrestart() {
  echo -n "Restarting services..." ;
	sudo service apache2 restart && echo -n "Apache restarted..." ;
	sudo service mysql restart && echo -n "MySQL restarted..." ;
  echo "DONE!" ;
}

##  chown dirctories under www
own() {
  if [[ -z $1 ]]; then
    echo "Argument required!" ;
  else
    p=`realpath $1` ;
    if [[ -d $p ]]; then
      sudo chown -R www-data:www-data $p && echo "www-data chowned '$1'" ;
    elif [[ -f $p ]]; then
      sudo chown www-data:www-data $p && echo "www-data chowned '$1'" ;
    else
      echo "'$1' not found" ;
    fi
  fi
}

##  chown dirctories
ownu() {
  if [[ -z $1 ]]; then
    echo "Argument required!" ;
  else
    p=`realpath $1` ;
    if [[ -d $p ]]; then
      sudo chown -R $USER:$USER $p && echo "$USER chowned '$1'" ;
    elif [[ -f $p ]]; then
      sudo chown $USER:$USER $p && echo "$USER chowned '$1'" ;
    else
      echo "'$1' not found" ;
    fi
  fi
}

##  shows apache error log
errorlog() {
  echo -e $f_red
	sudo tail /var/log/apache2/error.log ;
  echo " " ;
}

##  shows apache access log
accesslog() {
  echo -e $f_yellow
	sudo tail /var/log/apache2/access.log ;
  echo " " ;
}

##  edit php.ini
php.ini() {
	sudo $editor /etc/php5/apache2/php.ini ;
}

##  edit php-cli.ini
php-cli.ini() {
	sudo $editor /etc/php5/cli/php.ini ;
}

##  edit my.cnf
my.cnf() {
	sudo $editor /etc/mysql/my.cnf ;
}

##  create apache vhost
vhost() {
  vpath="/etc/apache2/sites-enabled"
  helptxt="
  Create virtual host:
      vhost <hostname> </path/to/docRoot>
  Delete virtual host:
      vhost --delete <hostname>
  Edit virtual host:
      vhost --edit <hostname>
  List virtual hosts:
      vhost --list
  Show this help:
      vhost --help
  "

  if [[ -z $1 ]]; then
    echo "Arguments required!"
    echo $helptxt
  else
    if [[ $1 == '--help' ]]; then
      echo $helptxt
    elif [[ $1 == '--list' ]]; then
      echo "sites-available:" && sudo ls "/etc/apache2/sites-available"
      echo "\nsites-enabled:" && sudo ls $vpath
    elif [[ $1 == '--delete' ]]; then
      if [[ -z $2 ]]; then
        echo "Nothing to delete!"
      elif [[ ! -f "$vpath/$2.conf" ]]; then
        echo "Vhost '$2' not found!"
      else
        sudo rm "/etc/apache2/sites-available/$2.conf" && sudo a2dissite $2.conf && echo "Deleted vhost"
        if grep -q "$2" "/etc/hosts"; then
          sudo sed -i.backup "/$2/d" "/etc/hosts" && echo "Removed entry from '/etc/hosts'.\nPlease restart apache2."
        fi
      fi
    elif [[ $1 == '--edit' ]]; then
      if [[ -z $2 ]]; then
        echo "Nothing to edit!"
      elif [[ ! -f "$vpath/$2.conf" ]]; then
        echo "Vhost '$2' not found!"
      else
        sudo $editor "$vpath/$2.conf"
      fi
    elif [[ ! -z $1 && ! -z $2 ]]; then
      if [[ "$1" =~ "^[A-Za-z0-9._]+$" && -d $2 ]]; then

        echo ""
vtemplate="<VirtualHost *:80>
  ServerAdmin admin@example.com
  ServerName $1
  ServerAlias $1
  DocumentRoot $2
  ErrorLog \${APACHE_LOG_DIR}/error.log
  CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>"

        avpath="/etc/apache2/sites-available/$1.conf"
        sudo touch $avpath && echo $vtemplate | sudo tee $avpath && echo "\nAdded above apache2 vhost entry\n"
        sudo a2ensite "$1.conf" && echo "Enabled new vhost\n"
        sudo echo "127.0.0.1  $1" | sudo tee --append /etc/hosts && echo "Added above '/etc/hosts' entry\n"
        echo "Vhost is ready. Please restart apache2 server.\n"
      else
        echo 'Invalid vhost name or docroot!'
      fi
    else
      echo "Invalid argument!"
      echo $helptxt
    fi
  fi
}
