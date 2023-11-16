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
					local theme = colors.theme
					return {
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						Folded = { bg = "none" },
						NormalFloat = { bg = "none" },
						TelescopeBorder = { bg = "none" },
						TelescopePreviewTitle = { fg = theme.ui.bg_dim, bg = theme.diag.ok, bold = true },
						TelescopePromptTitle = { fg = theme.ui.bg_dim, bg = theme.diag.warning, bold = true },
						TelescopeResultsTitle = { fg = theme.ui.bg_dim, bg = theme.diag.info, bold = true },
						Whitespace = { fg = "#30304a" },
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
			theme.normal.c.bg = "#282727"
			theme.inactive.c.bg = "#282727"

			require("lualine").setup({
				options = {
					theme = theme,
					globalstatus = false,
					section_separators = "",
					component_separators = "|",
				},
				sections = {
					lualine_a = {
						{
							"buffers",
							symbols = {
								alternate_file = "",
							},
							use_mode_colors = true,
							buffers_color = {
								active = { gui = "bold" },
							},
							cond = function()
								return vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
						{
							"tabs",
							cond = function()
								return #vim.api.nvim_list_tabpages() > 1 and vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
					},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
							file_status = false,
						},
					},
					lualine_x = {
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_y = {
						{
							"branch",
							icon = "",
							color = { gui = "bold" },
							cond = function()
								return vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
					},
					lualine_z = {
						{
							"location",
							color = { gui = "bold" },
							cond = function()
								return vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
					},
				},
				inactive_sections = {
					lualine_c = { { "filename", file_status = false } },
					lualine_x = {
						{
							"location",
							cond = function()
								return vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
					},
				},
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File browser" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			window = {
				width = 30,
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				follow_current_file = {
					enabled = true,
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(_)
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			notification = {
				override_vim_notify = true,
				window = {
					winblend = 0,
				},
			},
		},
	},
}
