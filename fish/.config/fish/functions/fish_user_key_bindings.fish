function fish_user_key_bindings
	bind \cr __fzf_history
	bind \cf __fzf_fd_nvim
	bind \cl __clear

	if bind -M insert > /dev/null 2>&1
		bind -M insert \cr __fzf_history
		bind -M insert \cf __fzf_fd_nvim
		bind -M insert \cl __clear
	end
end

function __fzf_history -d "Show command history"
	history -z |
		fzf --scheme=history --header "Command history:" --read0 --print0 |
		read -lz result
	and commandline -- $result
	commandline -f repaint
end

function __fzf_fd_nvim -d "Change directory and open neovim"
	fd -d 4 -E '/\.cache/' -t d -I --prune --hidden '\.git$' "$HOME" -x echo {//} |
		sort |
		fzf --scheme=path --header 'Git projects:' |
		read -l result
	and cd $result
	and commandline -- nvim
	commandline -f repaint
end

function __clear
	clear
	commandline -f repaint
end
