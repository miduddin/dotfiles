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
			local theme = require("lualine.themes.auto")
			theme.inactive.c.bg = theme.normal.c.bg
			local listed_buffer = function()
				return vim.fn.buflisted(vim.fn.bufnr()) == 1
			end

			require("lualine").setup({
				options = {
					theme = theme,
					globalstatus = false,
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
					lualine_y = { { "branch", icon = "", color = { gui = "bold" }, cond = listed_buffer } },
					lualine_z = { { "location", color = { gui = "bold" }, cond = listed_buffer } },
				},
				inactive_sections = {
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { { "location", cond = listed_buffer } },
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
			{ "<leader>bd", "<cmd>BufDel<cr>", { desc = "Close current buffer" } },
			{ "<leader>bD", "<cmd>BufDelOthers<cr>", { desc = "Close all other buffers" } },
		},
		opts = { quit = false },
	},
}
