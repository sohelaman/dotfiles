
# FISH SHELL SCRIPT


# Misc
abbr -a date1 'date "+%F %T"'
abbr -a date2 'date "+%F_%H%M%S"'
abbr -a pac sudo pacman -S
abbr -a apt sudo apt install
abbr -a catssh 'cat ~/.ssh/id_rsa.pub | ssh USER@HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"'
abbr -a sd sudo systemctl
abbr -a d sudo docker
abbr -a dc sudo docker-compose

# Git
abbr -a g git
abbr -a gco git checkout
abbr -a gcm git commit -m
abbr -a gap git add -p
abbr -a gpl git pull origin
abbr -a gps git push origin
abbr -a gbr git branch -r
