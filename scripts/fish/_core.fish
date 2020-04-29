
# FISH SHELL SCRIPT

###
# Include dotenv file variables
##
function dotenv
    if test -f $argv[1]
        export (grep "\S" $argv[1] | grep -v '^#' | xargs -n1)
    end
end
