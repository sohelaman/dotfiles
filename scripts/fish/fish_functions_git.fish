
# FOR FISH SHELL ONLY

# git aliases
function git_change_commit
    set_color yellow; git diff-tree --no-commit-id --name-only -r $argv ; set_color normal;
end

function gs
    git status
end

function gst
    git status
end

function gcmsg
    git commit -m "$argv"
end

function gco
    git checkout $argv
end

function ga
    git add $argv
end

function gap
    git add -p $argv
end

function gl
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
end

function gpl
    git pull $argv
end

function gps
    git push $argv
end

function gf
    git fetch $argv
end

function gfa
    git fetch --all
end

function gfo
    git fetch origin
end

function gc
    git commit
end

function gsh
    git show $argv
end

function grm
    git remove $argv
end

function gm
    git merge $argv
end

function gd
    git diff $argv
end

function gb
    git branch
end
