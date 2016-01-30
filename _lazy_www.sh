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
    #sudo chown -R $USER:$USER `pwd` ;
    #sudo chown -R www-data:www-data `pwd` ;
    #sudo chmod -R 755 `pwd` ;
    echo "Argument required!" ;
  else
    if [[ -d `pwd`/$1 ]]; then
      sudo chown -R www-data:www-data `pwd`/$1 ;
      echo "www-data chowned '$1'" ;
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
    if [[ -d `pwd`/$1 ]]; then
      sudo chown -R $USER:$USER `pwd`/$1 ;
      echo "$USER chowned '$1'" ;
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
