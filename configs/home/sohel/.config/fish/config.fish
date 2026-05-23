
#if status --is-login
#	if test -z "$DISPLAY" -a $XDG_VTNR = 1
#		exec startx
#	end
#end

source ~/.dotfiles/scripts/scripts-bootstrap.fish


# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/sohel/.lmstudio/bin
# End of LM Studio CLI section


# Hermes Agent — ensure ~/.local/bin is on PATH
fish_add_path "$HOME/.local/bin"
