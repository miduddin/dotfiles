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

vim.keymap.set("n", "<Leader><Space>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<M-b>", fzf.buffers, { desc = "Open buffers" })
vim.keymap.set("n", "<Leader>fb", fzf.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<Leader>fc", fzf.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<Leader>ff", fzf.git_bcommits, { desc = "File history" })
vim.keymap.set("n", "<Leader>fg", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<Leader>fh", fzf.help_tags, { desc = "Help pages" })
vim.keymap.set("n", "<Leader>fk", fzf.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<Leader>fr", fzf.resume, { desc = "Resume last search" })
vim.keymap.set("n", "<Leader>fs", fzf.lsp_document_symbols, { desc = "Symbols (document)" })
vim.keymap.set("n", "<Leader>fw", fzf.grep_cword, { desc = "Find word under cursor" })
vim.keymap.set("v", "<Leader>fw", fzf.grep_visual, { desc = "Find selected text" })
vim.keymap.set("n", "<Leader>f<tab>", fzf.tabs, { desc = "List tabs" })
