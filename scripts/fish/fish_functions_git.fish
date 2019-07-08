
# FISH SHELL SCRIPT


###
# List files impacted in a commit or list of commits.
#
# $argv string commit SHA1. Can provide a list of SHA1 seperated by spaces.
##
function git_commit_filelist
    set_color yellow; git diff-tree --no-commit-id --name-only -r $argv ; set_color normal;
end


###
# Better visual representation of git log
##
function gl
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
end

function gs
    git status
end

function gco
    git checkout $argv
end

function gfa
    git fetch --all
end
