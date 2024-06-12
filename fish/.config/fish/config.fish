if status is-interactive
	# Commands to run in interactive sessions can go here
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
