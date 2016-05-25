
# Lazy Do Such Things

## Shell Shortcuts
**For Debian and derivatives.**
**Requires superuser.**

****************************************************************************************
Terminal commands are shown with starting '$'. Exclude '$' while copying.
****************************************************************************************

### Install
Download source, 'cd' to *lazy_do_so* directory and enter following commands,
```shell
$ chmod +x install.sh
$ ./install.sh
```

### Manual Install
1. Copy this *lazy_do_so* directory to your home directory and add this line to your .bashrc or .zshrc file,
```shell
source ~/lazy_do_so/lazycomm.sh
```

### Uninstall
Use given *uninstall.sh* script,
```shell
$ chmod +x uninstall.sh
$ ./uninstall.sh
```

### Documentation

**Shutdown easily.**
```shell
$ term
$ term --help
```

**Edit Debian software sources. REQUIRES sudo.**
```shell
$ src
```

**Shortcut for sudo apt-get install. REQUIRES sudo.**
```shell
$ get       # Executes sudo apt-get update
$ get vim   # Executes sudo apt-get install vim
```

**Clean apt-cache and remove unnecessary packages. REQUIRES sudo.**
```shell
$ clean
```

**Cow moos your fortune. Install REQUIRES sudo.**
```shell
$ fortunecookie
```

**Jump to www directory.**
```shell
$ www
```

**Start/stop/restart apache, mysql server. REQUIRES sudo.**
```shell
$ webstart
$ webstop
$ webrestart
```

**Tail of apache error log and access log. REQUIRES sudo.**
```shell
$ errorlog
$ accesslog
```

**Edit php.ini and mysql.cnf. REQUIRES sudo.**
```shell
$ php.ini
$ php-cli.ini
$ my.cnf
```

**Create, edit, delete apache2 virtual hosts. REQUIRES sudo.**
```shell
$ vhost --help                                # Shows help
$ vhost --list                                # Lists current virtual hosts
$ vhost example.com /path/to/document/root    # Create virtual host
$ vhost --edit example.com                    # Edit virtual host
$ vhost --delete example.com                  # Delete virtual host
```

**Display weather in terminal. Thanks to *http://wttr.in/* REQUIRES cURL and internet.**
```shell
$ weather
$ weather New\ Yrok
```

**Record audio and save to a wav file.**
```shell
$ record	     # Records to file ~/Music/record_<date_time>.wav
$ record abc	 # Records to file <Current Directory>/abc.wav
```

**Record screen and save to a GIF file.**
```shell
$ screengif 15 abc	# Records 15 seconds and saves to file <Current Directory>/abc.gif
```

