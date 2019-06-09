
# My Dotfiles

## Mostly for Archlinux/Debian or alternatives.
## Config/scripts include:
- Fish shell
- i3
- Couple other configs

***USE AT YOUR OWN RISK***

**Some commands/shortcuts require superuser access.**

## HowTo
### Clone the repo to your *home* directory
```shell
$ cd ~
$ git clone https://github.com/sohelaman/dotfiles.git .dotfiles
```

### Take a look at the installer script
- The installer script is called ***install.sh***
- It resides at the root of the repository.
- Verify the *fileset* arrays and confirm that all unnecessary scripts are commented out. For example, following script is commented out, I prefer to put the fish config manually.
```
#fileset_home+=(.config/fish/config.fish)
```

### Run the installer script (fish shell)
```shell
$ cd ~
$ ./install.sh | tee ./logs/install_(date +%s).log
```

### Add following line to your fish config ***~/.config/fish/config.fish*** file,
```
source ~/.dotfiles/scripts/scripts-bootstrap.fish
```
