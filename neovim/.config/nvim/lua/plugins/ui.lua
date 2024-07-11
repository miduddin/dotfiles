return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
				transparent = true,
				colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
				overrides = function(colors)
					local theme = colors.theme
					return {
						Folded = { bg = "none" },
						Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
						PmenuThumb = { bg = theme.ui.bg_p2 },
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
		"b0o/incline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local colors = require("config.colors")
			local ignore_types = {
				"DiffviewFiles",
				"Trouble",
			}
			local type_name = {
				oil = "File Explorer",
				["neotest-summary"] = "Test Summary",
			}

			require("incline").setup({
				render = function(props)
					local filetype = vim.bo[props.buf].filetype
					local filename = type_name[filetype]
						or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

					if vim.list_contains(ignore_types, filetype) or filename == "" then
						return {}
					end

					local modified = vim.bo[props.buf].modified
					return {
						{ "", guifg = colors.blue, guibg = "none" },
						{ " ", filename, modified and " [+]" or "", " ", guibg = colors.blue },
					}
				end,
				window = {
					margin = { horizontal = 0, vertical = 0 },
					padding = 0,
				},
				highlight = {
					groups = {
						InclineNormal = { guifg = colors.black, gui = "bold" },
						InclineNormalNC = { guifg = colors.black, gui = "bold" },
					},
				},
				ignore = {
					unlisted_buffers = false,
					buftypes = { "help", "quickfix", "terminal" },
					wintypes = {},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
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
		opts = {},
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
		event = "VeryLazy",
		keys = {
			{ "<leader>ba", "<cmd>BufDelAll<cr>", desc = "Close all buffers" },
			{ "<leader>bd", "<cmd>BufDel<cr>", desc = "Close current buffer" },
			{ "<leader>bo", "<cmd>BufDelOthers<cr>", desc = "Close other buffers" },
		},
		opts = { quit = false },
	},
}
