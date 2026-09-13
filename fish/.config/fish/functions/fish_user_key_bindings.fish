function fish_user_key_bindings
	bind ctrl-r __fzf_history
	bind ctrl-f __fzf_fd_nvim
	bind ctrl-l __clear
	bind alt-v __open_buffer

	if bind -M insert > /dev/null 2>&1
		bind -M insert ctrl-r __fzf_history
		bind -M insert ctrl-f __fzf_fd_nvim
		bind -M insert ctrl-l __clear
		bind -M insert alt-v __open_buffer
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
	fd -d 4 -t d -I --prune --hidden '\.git$' "$HOME/.local" "$HOME/code" "$HOME/dotfiles" -x echo {//} |
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

function __open_buffer
	nvim /mnt/d/term_buffer && rm /mnt/d/term_buffer 2> /dev/null
end
