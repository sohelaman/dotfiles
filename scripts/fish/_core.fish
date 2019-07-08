
# FISH SHELL SCRIPT

###
# Include dotenv file variables
##
function dotenv
  if test -f $argv[1]
    export (grep -v '^#' $argv[1] | xargs -d '\n')
  end
end
