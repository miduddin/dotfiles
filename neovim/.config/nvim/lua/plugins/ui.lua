return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
				colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
				overrides = function(colors)
					local theme = colors.theme
					return {
						DiffDelete = { fg = "none", bg = theme.diff.delete },
						DiffviewDiffDeleteDim = { fg = theme.ui.bg_p2 },
						Folded = { bg = "none" },
						Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
						PmenuThumb = { bg = theme.ui.bg_p2 },
						StatusLine = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
						StatusLineNC = { fg = theme.ui.float.fg_border, bg = theme.ui.bg },
						Whitespace = { fg = theme.ui.bg_p2 },
						WinSeparator = { fg = theme.ui.float.fg_border },
					}
				end,
			})
			vim.cmd([[colorscheme kanagawa]])
			vim.api.nvim_set_hl(0, "@string.special.url", { undercurl = false, fg = "#7fb4ca" })
		end,
	},
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
		opts = { input = { start_in_insert = false } },
	},
	{
		"echasnovski/mini.notify",
		event = "VeryLazy",
		config = function()
			local notify = require("mini.notify")
			notify.setup({ window = { winblend = 0 } })
			vim.notify = notify.make_notify()
		end,
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
