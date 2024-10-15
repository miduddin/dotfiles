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
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = { start_in_insert = false },
			select = { backend = { "builtin" } },
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = { notification = { override_vim_notify = true } },
	},
	{
		"ojroques/nvim-bufdel",
		keys = {
			{ "<Leader>ba", "<Cmd>BufDelAll<CR>", desc = "Close all buffers" },
			{ "<Leader>bd", "<Cmd>BufDel<CR>", desc = "Close current buffer" },
			{ "<Leader>bo", "<Cmd>BufDelOthers<CR>", desc = "Close other buffers" },
		},
		opts = { quit = false },
	},
	{
		"echasnovski/mini.tabline",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("mini.tabline").setup(opts)
			vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "StFilename" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { link = "MiniTablineCurrent" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { link = "MiniTablineVisible" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { link = "MiniTablineHidden" })
		end,
	},
}
