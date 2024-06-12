if status is-interactive
	# Commands to run in interactive sessions can go here
end

source ~/.phpbrew/phpbrew.fish
direnv hook fish | source

starship init fish | source
