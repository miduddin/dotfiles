function ls --description 'List contents of directory'
	if command -q eza
		eza $argv
		return
	end

	# Original fish built-in below

	if not set -q __fish_ls_color_opt
		set -g __fish_ls_color_opt
		set -g __fish_ls_command ls
		if command -sq colorls
			and command colorls -GF >/dev/null 2>/dev/null
			set -g __fish_ls_color_opt -GF
			set -g __fish_ls_command colorls
		else
			for opt in --color=auto -G --color -F
				if command ls $opt / >/dev/null 2>/dev/null
					set -g __fish_ls_color_opt $opt
					break
				end
			end
		end
	end

	__fish_set_lscolors

	isatty stdout
	and set -a opt -F

	test "$TERM_PROGRAM" = Apple_Terminal
	and set -lx CLICOLOR 1

	command $__fish_ls_command $__fish_ls_color_opt $opt $argv
end

function __fish_set_lscolors --description 'Set $LS_COLORS if possible'
	if ! set -qx LS_COLORS && set -l cmd (command -s {g,}dircolors)[1]
		set -l colorfile
		for file in ~/.dir_colors ~/.dircolors /etc/DIR_COLORS
			if test -f $file
				set colorfile $file
				break
			end
		end
		# Here we rely on the legacy behavior of `dircolors -c` producing output
		# suitable for csh in order to extract just the data we're interested in.
		set -gx LS_COLORS ($cmd -c $colorfile | string split ' ')[3]
		# The value should always be quoted but be conservative and check first.
		if string match -qr '^([\'"]).*\1$' -- $LS_COLORS
			set LS_COLORS (string match -r '^.(.*).$' $LS_COLORS)[2]
		end
	end
end
