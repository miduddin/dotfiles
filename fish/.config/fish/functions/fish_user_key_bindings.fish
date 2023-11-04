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
	set -lx FZF_DEFAULT_OPTS "--height 10 --scheme=history $FZF_DEFAULT_OPTS"
	history -z | eval "fzf" --read0 --print0 -q '(commandline)' | read -lz result
	and commandline -- $result
	commandline -f repaint
end

function __fzf_fd_nvim -d "Change directory and open neovim"
	set -lx FZF_DEFAULT_OPTS "--height 10 --scheme=path $FZF_DEFAULT_OPTS"
	fd -d 4 -t d -I --prune --hidden '\.git$' "$HOME" -x echo {//} | sort | fzf | read -l result
	and cd $result
	and commandline -- nvim
	commandline -f repaint
end

function __clear
	clear
	commandline -f repaint
end
