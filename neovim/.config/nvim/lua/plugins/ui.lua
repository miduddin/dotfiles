return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
				background = {
					dark = "wave",
				},
				transparent = true,
				colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
				overrides = function(colors)
					return {
						DiagnosticFloatingOk = { bg = "none" },
						DiagnosticFloatingHint = { bg = "none" },
						DiagnosticFloatingInfo = { bg = "none" },
						DiagnosticFloatingWarn = { bg = "none" },
						DiagnosticFloatingError = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						Folded = { bg = "none" },
						NormalFloat = { bg = "none" },
						Whitespace = { fg = "#40405a" },
						WinSeparator = { fg = "#54546d" },
					}
				end,
			})
			vim.cmd([[colorscheme kanagawa]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local colors = require("config.colors")

			local conds = {
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				listed_buffer = function()
					return vim.fn.buflisted(vim.fn.bufnr()) == 1
				end,
			}

			require("lualine").setup({
				options = {
					globalstatus = true,
					section_separators = "",
					component_separators = "",
					theme = {
						normal = {
							a = { fg = colors.black, bg = colors.blue, gui = "bold" },
							c = { fg = colors.fg, bg = colors.bg },
						},
						inactive = {
							a = { fg = colors.black, bg = colors.blue, gui = "bold" },
							c = { fg = colors.fg, bg = colors.bg },
						},
					},
				},
				extensions = {
					"nvim-dap-ui",
					"oil",
					"quickfix",
					"trouble",
				},
				sections = {
					lualine_a = { { "filename", path = 1 } },
					lualine_b = {},
					lualine_c = { { "diagnostics" } },
					lualine_x = {
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							cond = conds.hide_in_width,
						},
						{ "branch", color = { fg = colors.magenta, gui = "bold" } },
						{
							"filetype",
							cond = conds.listed_buffer,
						},
						{ "progress" },
						{ "location" },
						{
							function()
								return "▊"
							end,
							color = { fg = colors.blue },
							padding = { left = 1 },
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		"b0o/incline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local colors = require("config.colors")
			local icons = require("nvim-web-devicons")
			local helpers = require("incline.helpers")
			local ignore_types = {
				"DiffviewFiles",
				"Trouble",
			}
			local type_name = {
				oil = "File Explorer",
			}

			require("incline").setup({
				render = function(props)
					local filetype = vim.bo[props.buf].filetype
					local filename = type_name[filetype]
						or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

					if vim.list_contains(ignore_types, filetype) or filename == "" then
						return {}
					end

					local ft_icon, ft_color = icons.get_icon_color(filename)

					local modified = vim.bo[props.buf].modified
					return {
						ft_icon and {
							" ",
							ft_icon,
							" ",
							guibg = ft_color,
							guifg = helpers.contrast_color(ft_color),
						} or "",
						" ",
						filename,
						modified and " [+]" or "",
						" ",
					}
				end,
				window = {
					margin = { horizontal = 0, vertical = 0 },
					padding = 0,
				},
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.blue, guifg = colors.black, gui = "bold" },
						InclineNormalNC = { guibg = colors.blue, guifg = colors.black, gui = "bold" },
					},
				},
				ignore = {
					unlisted_buffers = false,
					buftypes = { "help", "quickfix" },
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

			notify.setup({
				window = { winblend = 0 },
			})

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
