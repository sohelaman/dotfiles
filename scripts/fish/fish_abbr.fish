
# FISH SHELL SCRIPT


# Misc
abbr -a date1 'date "+%F %T"'
abbr -a date2 'date "+%F_%H%M%S"'
abbr -a pac sudo pacman -S
abbr -a apt sudo apt-get install
abbr -a catssh 'cat ~/.ssh/id_rsa.pub | ssh USER@HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"'
abbr -a sd sudo systemctl

# Docker
abbr -a d docker
abbr -a di docker images
abbr -a dc docker-compose
abbr -a dcu docker-compose up -d
abbr -a dcd docker-compose down
abbr -a dce docker-compose exec

# Git
abbr -a g git
abbr -a gd git diff
# abbr -a gl git log ## not needed, a function is defined for expressive output.
abbr -a gm git merge
abbr -a gs git status
abbr -a gls git ls-files
abbr -a glo git log --oneline --graph
abbr -a gco git checkout
abbr -a gcp git cherry-pick
abbr -a gls git ls-files
abbr -a gcm git commit -m "Fixes"
abbr -a gap git add -p
abbr -a gpl git pull origin
abbr -a gps git push origin
abbr -a gbr git branch -r
abbr -a gfa git fetch --all
abbr -a gta git tag -a 1.0 -m "Version 1.0"
