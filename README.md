
# My Dotfiles

## For [Arch Linux](https://www.archlinux.org/), [Debian](https://www.debian.org/) or derivatives
## What's included
- [Fish shell](http://fishshell.com/) shortcuts, aliases, etc.
- [i3wm](https://i3wm.org/) and related configurations.
- Couple other minor configs. See inside the [*config*](https://github.com/sohelaman/dotfiles/tree/master/configs) directory.

***CAUTION! USE AT YOUR OWN RISK***

**Some commands/shortcuts will require sudo.**

## Background
- Dotfiles are quite personalized configurations. From my experiences, most of the time, one person does not like someone else's personalizations. Hence, it is always better not to use someone else's dotfiles entirely. Instead, go through and handpick what you like.
- I would discourage using the included installer script as it is not tested like a practical software in various environments. If you wish to use it anyway, make sure to check the terminal output; which is again logged inside the *logs* directory.

## Installation

### Clone the repo to the *home* directory
```shell
$ cd ~ && git clone https://github.com/sohelaman/dotfiles.git .dotfiles
```

### Take a look at the [installer configuration](install.conf.sh)
- The installer uses a config script called ***install.conf.sh*** to determine what to install.
- In that file, verify the *fileset* arrays and confirm that all unnecessary scripts are commented out.
- For example, following script is commented out, I prefer to put the Fish config manually.
```shell
#fileset_home+=(.config/fish/config.fish)
```

### Run the installer script
- Fish
```shell
$ cd ~/.dotfiles ; and ./install.sh | tee ./logs/install_(date +%s).log
```
- Bash/Zsh
```shell
$ cd ~/.dotfiles && ./install.sh | tee ./logs/install_$(date +%s).log
```

### Manually include the bootstrap file to the Fish config
- Ignore this step should you be using Bash or other shells.
- Add following line to the Fish config ***~/.config/fish/config.fish***
```
source ~/.dotfiles/scripts/scripts-bootstrap.fish
```

I shall add docs on the Fish shell shortcuts/aliases soon.
