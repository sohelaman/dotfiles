
# FISH SHELL SCRIPT


# Misc
abbr -a ll exa -lah
abbr -a date1 'date "+%F %T"'
abbr -a date2 'date "+%F_%H%M%S"'
abbr -a catssh 'cat ~/.ssh/id_rsa.pub | ssh USER@HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"'
abbr -a sd sudo systemctl
abbr -a fix_rotation xrandr -o normal

# Package managers
if type -q pacman
    abbr -a pac sudo pacman -S
else if type -q apt
    abbr -a apti sudo apt install
    abbr -a aptr sudo apt remove
    abbr -a aptu 'sudo apt update && sudo apt dist-upgrade'
else if type -q dnf
    abbr -a dnfi sudo dnf install
    abbr -a dnfr sudo dnf remove
    abbr -a dnfu 'sudo dnf makecache && sudo dnf upgrade'
end

# Docker
abbr -a d docker
abbr -a di docker images
abbr -a dc docker compose
abbr -a docker-compose docker compose
abbr -a dcu docker compose up -d
abbr -a dcd docker compose down
abbr -a dce docker compose exec
abbr -a doc cd $www_dir/dockerized/docroot

# Artisan
abbr -a pas php artisan serve
abbr -a pao php artisan optimize
abbr -a pacc 'php artisan cache:clear && php artisan route:clear && php artisan config:clear && php artisan clear-compiled'

# Git
abbr -a g git
abbr -a gd git diff
abbr -a gm git merge
abbr -a gs git status
abbr -a gsh git show
abbr -a gst git stash
abbr -a glo git log --oneline --graph
abbr -a gco git checkout
abbr -a gcp git cherry-pick
abbr -a gls git ls-files
abbr -a gcm git commit -m "Fixes"
abbr -a gap git add -p
abbr -a gpl git pull origin
abbr -a gps git push origin
abbr -a gb git branch
abbr -a gbr git branch -r
abbr -a gfa git fetch --all --tags
abbr -a gta git tag -a 1.0 -m "Version 1.0"
