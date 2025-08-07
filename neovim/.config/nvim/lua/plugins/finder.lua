local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		preview = {
			delay = 0,
			layout = "vertical",
			vertical = "down:75%",
			winopts = { number = false },
		},
	},
	defaults = {
		formatter = "path.filename_first",
	},
	file_icon_padding = " ",
	files = {
		fd_opts = "--color=never --type f --hidden --follow "
			.. "--exclude .git/ --exclude node_modules/ --exclude vendor/",
		previewer = false,
		winopts = { height = 20 },
	},
	grep = {
		rg_opts = "--column --line-number --no-heading --hidden --multiline "
			.. "--color=always --smart-case --max-columns=4096 "
			.. "-g '!.git/' -g '!node_modules/' -g '!vendor/' -e",
	},
	git = {
		branches = {
			actions = {
				["enter"] = function(selected) vim.cmd("DiffviewOpen " .. selected[1]) end,
			},
		},
		bcommits = {
			fzf_opts = {
				["--exact"] = true,
				["--no-sort"] = true,
			},
		},
		commits = {
			actions = {
				["enter"] = function(selected)
					local sha = selected[1]:match("[^ ]+")
					vim.cmd("DiffviewOpen " .. sha .. "^.." .. sha)
				end,
			},
			fzf_opts = {
				["--exact"] = true,
				["--no-sort"] = true,
			},
		},
	},
})

Map("<Leader><Space>", fzf.files, "n", { desc = "Find files" })
Map("<Leader>f<tab>", fzf.tabs, "n", { desc = "List tabs" })
Map("<Leader>fb", fzf.git_branches, "n", { desc = "Git branches" })
Map("<Leader>fc", fzf.git_commits, "n", { desc = "Git commits" })
Map("<Leader>ff", fzf.git_bcommits, "n", { desc = "File history" })
Map("<Leader>fg", fzf.live_grep, "n", { desc = "Live grep" })
Map("<Leader>fh", fzf.help_tags, "n", { desc = "Help pages" })
Map("<Leader>fk", fzf.keymaps, "n", { desc = "Keymaps" })
Map("<Leader>fr", fzf.resume, "n", { desc = "Resume last search" })
Map("<Leader>fs", fzf.lsp_document_symbols, "n", { desc = "Symbols (document)" })
Map("<Leader>fw", fzf.grep_cword, "n", { desc = "Find word under cursor" })
Map("<Leader>fw", fzf.grep_visual, "v", { desc = "Find selected text" })
Map("<M-b>", fzf.buffers, "n", { desc = "Open buffers" })
