function fish_user_key_bindings
	function cl
		clear
		commandline -f repaint
	end

	bind \cl cl

	if bind -M insert > /dev/null 2>&1
		bind -M insert \cl cl
	end
end

fzf_key_bindings
