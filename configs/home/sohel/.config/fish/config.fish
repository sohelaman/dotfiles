
if status --is-login
	if test -z "$DISPLAY" -a $XDG_VTNR = 1
		exec startx
	end
end

source ~/.dotfiles/scripts/scripts-bootstrap.fish

