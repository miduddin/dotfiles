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
local fzfd = require("fzf-lua.defaults")
fzf.setup({
	"border-fused",
	ui_select = true,
	winopts = {
		width = 120,
		preview = {
			layout = "vertical",
			vertical = "down:75%",
			winopts = { number = false },
		},
	},
	files = {
		fd_opts = "--hidden --follow " .. fzfd.defaults.files.fd_opts,
		previewer = false,
		winopts = { height = 20 },
	},
	grep = {
		rg_opts = "--hidden --multiline -g '!.git/' " .. fzfd.defaults.grep.rg_opts,
	},
	git = {
		branches = {
			actions = {
				["enter"] = function(selected) vim.cmd("DiffviewOpen " .. selected[1]) end,
			},
			preview = false,
			winopts = { height = 20 },
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
	marks = { marks = "%a" },
})

Map("<Leader><Space>", fzf.files, "n", { desc = "fzf: files" })
Map("<Leader>f<Tab>", fzf.tabs, "n", { desc = "fzf: tabs" })
Map("<Leader>fb", fzf.git_branches, "n", { desc = "fzf: git branches" })
Map("<Leader>fc", fzf.git_bcommits, "n", { desc = "fzf: git commits (file)" })
Map("<Leader>fC", fzf.git_commits, "n", { desc = "fzf: git commits (project)" })
Map("<Leader>fg", fzf.live_grep, "n", { desc = "fzf: grep" })
Map("<Leader>fh", fzf.help_tags, "n", { desc = "fzf: help files" })
Map("<Leader>fk", fzf.keymaps, "n", { desc = "fzf: keymaps" })
Map("<Leader>fm", fzf.marks, "n", { desc = "fzf: marks" })
Map("<Leader>fq", fzf.quickfix, "n", { desc = "fzf: quickfix" })
Map("<Leader>fQ", fzf.quickfix_stack, "n", { desc = "fzf: quickfix stack" })
Map("<Leader>fr", fzf.resume, "n", { desc = "fzf: resume last" })
Map("<Leader>fs", fzf.lsp_document_symbols, "n", { desc = "fzf: lsp document symbols" })
Map("<Leader>fw", fzf.grep_cword, "n", { desc = "fzf: grep current word" })
Map("<Leader>fw", fzf.grep_visual, "v", { desc = "fzf: grep visual" })
