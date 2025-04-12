if status is-interactive
	# Commands to run in interactive sessions can go here
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
