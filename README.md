
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

**1. Shutdown easily.**
```shell
$ term
$ term --help
```

**2. Edit Debian software sources. REQUIRES sudo.**
```shell
$ src
```

**3. Clean apt-cache and remove unnecessary packages. REQUIRES sudo.**
```shell
$ clean
```

**4. Cow says your fortune. Install REQUIRES sudo.**
```shell
$ fortunecookie
```

**5. Jump to www directory.**
```shell
$ www
```

**6. Start/stop/restart apache, mysql server. REQUIRES sudo.**
```shell
$ webstart
$ webstop
$ webrestart
```

**7. Tail of apache error log and access log. REQUIRES sudo.**
```shell
$ errorlog
$ accesslog
```

**8. Edit php.ini and mysql.cnf. REQUIRES sudo.**
```shell
$ php.ini
$ php-cli.ini
$ my.cnf
```

**9. Display weather in terminal. Thanks to *http://wttr.in/* REQUIRES cURL and internet.**
```shell
$ weather
$ weather New\ Yrok
```

**10. Record audio and save to a wav file.**
```shell
$ record	# Records to file ~/Music/record_<date_time>.wav
$ record abc	# Records to file <Current Directory>/abc.wav
```

