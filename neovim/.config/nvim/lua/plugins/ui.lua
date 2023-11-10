return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					dap = { enabled = true, enable_ui = true },
					neotest = true,
					neotree = true,
					telescope = { enabled = true },
				},
				custom_highlights = function(c)
					return {
						TelescopePreviewTitle = {
							fg = c.base,
							bg = c.green,
							style = { "bold" },
						},
						TelescopePromptTitle = {
							fg = c.base,
							bg = c.red,
							style = { "bold" },
						},
						TelescopeResultsTitle = {
							fg = c.mantle,
							bg = c.lavender,
							style = { "bold" },
						},
					}
				end,
			})
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local theme = require("lualine.themes.auto")
			theme.normal.c.bg = "#11111b"
			theme.inactive.c.bg = "#11111b"

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
							"filename",
							path = 1,
							file_status = false,
							color = { bg = "#22223e", fg = "#f5e0dc" },
						},
					},
					lualine_b = {},
					lualine_c = {
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_x = {
						{
							"buffers",
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
					lualine_y = {
						{
							"branch",
							icon = "",
							color = { bg = "#22223e", fg = "#f5c2e7", gui = "bold" },
							cond = function()
								return vim.fn.buflisted(vim.fn.bufnr()) == 1
							end,
						},
					},
					lualine_z = {
						{
							"location",
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
}
