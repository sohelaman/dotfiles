
# FISH SHELL SCRIPT


# The order of sourcing the following scripts is important.

source $DF_SCRIPTS_ROOT/fish/_core.fish

source $DF_SCRIPTS_ROOT/fish/fish_env.fish
source $DF_SCRIPTS_ROOT/fish/fish_paths.fish

source $DF_SCRIPTS_ROOT/fish/fish_aliases.fish
source $DF_SCRIPTS_ROOT/fish/fish_abbr.fish

source $DF_SCRIPTS_ROOT/fish/fish_functions.fish
source $DF_SCRIPTS_ROOT/fish/fish_functions_git.fish
source $DF_SCRIPTS_ROOT/fish/fish_functions_www.fish

/usr/bin/xbindkeys

