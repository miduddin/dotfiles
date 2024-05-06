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
			require("lualine").setup({
				options = {
					globalstatus = true,
					section_separators = "",
					component_separators = "|",
				},
				extensions = {
					"nvim-dap-ui",
					"oil",
					"quickfix",
					"trouble",
				},
				sections = {
					lualine_a = { { "filename", path = 1, color = { gui = "bold" } } },
					lualine_b = {},
					lualine_c = { "diagnostics" },
					lualine_x = {},
					lualine_y = { { "branch", color = { gui = "bold" } } },
					lualine_z = { { "location", color = { gui = "bold" } } },
				},
			})
		end,
	},
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		opts = {
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local modified = vim.bo[props.buf].modified
				return {
					" ",
					filename,
					modified and { " *", guifg = "#888888", gui = "bold" } or "",
					" ",
				}
			end,
			window = {
				margin = { horizontal = 0, vertical = 0 },
				padding = 0,
			},
			highlight = {
				groups = {
					InclineNormal = {
						default = true,
						group = "lualine_a_filename_normal",
					},
					InclineNormalNC = {
						default = true,
						group = "lualine_a_filename_normal",
					},
				},
			},
			ignore = {
				unlisted_buffers = false,
				buftypes = {},
				wintypes = {},
				filetypes = {
					"oil",
					"DiffviewFiles",
				},
			},
		},
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
