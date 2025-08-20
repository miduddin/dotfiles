local oil = require("oil")
oil.setup({
	keymaps = {
		["q"] = "actions.close",
		["<C-c>"] = false,
		["<C-s>"] = false,
		["`"] = false,
		["~"] = false,
	},
	view_options = { show_hidden = true },
})

Map("<Leader>e", oil.open, "n", { desc = "File explorer" })

local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		width = 120,
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

fzf.register_ui_select()

Map("<Leader><Space>", fzf.files, "n", { desc = "fzf: files" })
Map("<Leader>f<Tab>", fzf.tabs, "n", { desc = "fzf: tabs" })
Map("<Leader>fb", fzf.git_branches, "n", { desc = "fzf: git branches" })
Map("<Leader>fc", fzf.git_bcommits, "n", { desc = "fzf: git commits (file)" })
Map("<Leader>fC", fzf.git_commits, "n", { desc = "fzf: git commits (project)" })
Map("<Leader>fg", fzf.live_grep, "n", { desc = "fzf: grep" })
Map("<Leader>fh", fzf.help_tags, "n", { desc = "fzf: help files" })
Map("<Leader>fk", fzf.keymaps, "n", { desc = "fzf: keymaps" })
Map("<Leader>fq", fzf.quickfix, "n", { desc = "fzf: quickfix" })
Map("<Leader>fQ", fzf.quickfix_stack, "n", { desc = "fzf: quickfix stack" })
Map("<Leader>fr", fzf.resume, "n", { desc = "fzf: resume last" })
Map("<Leader>fs", fzf.lsp_document_symbols, "n", { desc = "fzf: lsp document symbols" })
Map("<Leader>fw", fzf.grep_cword, "n", { desc = "fzf: grep current word" })
Map("<Leader>fw", fzf.grep_visual, "v", { desc = "fzf: grep visual" })
