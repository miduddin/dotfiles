if status is-interactive
	set fish_vi_force_cursor 1
end

function storePathForWindowsTerminal --on-variable PWD
	if test -n "$WT_SESSION"
	  printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
	end
end

if test -f ~/.phpbrew/phpbrew.fish
	source ~/.phpbrew/phpbrew.fish
end

if type -q direnv
	direnv hook fish | source
end

if type -q starship
	starship init fish | source
end
