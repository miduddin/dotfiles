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

vim.keymap.set("n", "<Leader>e", oil.open, { desc = "File explorer" })

local snacks = require("snacks")
snacks.setup({
	input = { enabled = true },
	notifier = { enabled = true },
	picker = { enabled = true },

	styles = {
		input = {
			relative = "cursor",
			row = -3,
			col = 0,
			width = 30,
			keys = {
				i_esc = false,
			},
		},
	},
})

vim.keymap.set("n", "<Leader>n", snacks.notifier.show_history, { desc = "Notification history" })
vim.keymap.set("n", "<Leader>dpp", snacks.profiler.toggle, { desc = "Toggle profiler" })
vim.keymap.set("n", "<Leader>dph", snacks.profiler.highlight, { desc = "Toggle profiler highlight" })
vim.keymap.set("n", "<Leader>dps", snacks.profiler.highlight, { desc = "Profiler scratch buffer" })
