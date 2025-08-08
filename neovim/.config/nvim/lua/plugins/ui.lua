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

local snacks = require("snacks")
snacks.setup({
	bigfile = { enabled = true, notify = false },
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

Map("<Leader>sn", snacks.notifier.show_history, "n", { desc = "Notification history" })
Map("<Leader>sP", snacks.profiler.toggle, "n", { desc = "Toggle profiler" })
Map("<Leader>sph", snacks.profiler.highlight, "n", { desc = "Toggle profiler highlight" })
Map("<Leader>sps", snacks.profiler.scratch, "n", { desc = "Profiler scratch buffer" })
