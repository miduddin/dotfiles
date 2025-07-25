return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<Leader>e", "<Cmd>Oil<CR>", desc = "File explorer" },
		},
		opts = {
			keymaps = {
				["q"] = "actions.close",
				["<C-c>"] = false,
				["<C-s>"] = false,
				["`"] = false,
				["~"] = false,
			},
			view_options = { show_hidden = true },
		},
	},
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Leader>ba", "<Cmd>lua Snacks.bufdelete.all()<CR>", desc = "Close all buffers" },
			{ "<Leader>bd", "<Cmd>lua Snacks.bufdelete.delete()<CR>", desc = "Close current buffer" },
			{ "<Leader>bo", "<Cmd>lua Snacks.bufdelete.other()<CR>", desc = "Close other buffers" },
			{ "<Leader>gof", "<Cmd>lua Snacks.gitbrowse.open()<CR>", desc = "Open in git web", mode = { "n", "v" } },
			{ "<Leader>dpp", "<Cmd>lua Snacks.profiler.toggle()<CR>", desc = "Toggle profiler" },
			{ "<Leader>dph", "<Cmd>lua Snacks.profiler.highlight()<CR>", desc = "Toggle profiler highlight" },
			{ "<Leader>dps", "<Cmd>lua Snacks.profiler.highlight()<CR>", desc = "Profiler scratch buffer" },
		},
		opts = {
			gitbrowse = { enabled = true },
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
		},
	},
}
