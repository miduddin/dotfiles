function fzf_key_bindings

	function fzf-history-widget -d "Show command history"
		set -lx FZF_DEFAULT_OPTS "--height 10 $FZF_DEFAULT_OPTS --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m"
		history -z | eval "fzf" --read0 --print0 -q '(commandline)' | read -lz result
		and commandline -- $result
		commandline -f repaint
	end

	function fzf-fd-nvim -d "Change directory and open neovim"
		set -lx FZF_DEFAULT_OPTS "--height 10 --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS"
		fd -d 4 -t d -I --prune --hidden '\.git$' "$HOME" -x echo {//} | sort | fzf | read -l result
		and cd $result
		and commandline -- nvim
		commandline -f repaint
	end

	bind \cr fzf-history-widget
	bind \cf fzf-fd-nvim

	if bind -M insert > /dev/null 2>&1
		bind -M insert \cr fzf-history-widget
		bind -M insert \cf fzf-fd-nvim
	end
end
