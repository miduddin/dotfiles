return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					dap = { enabled = true, enable_ui = true },
					navic = { enabled = true, custom_bg = "NONE" },
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
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"SmiteshP/nvim-navic",
			"folke/noice.nvim",
		},
		config = function()
			local dir = vim.loop.cwd():gsub(".*/", "")

			require("lualine").setup({
				options = {
					globalstatus = true,
					section_separators = "",
					component_separators = "|",
					disabled_filetypes = {
						winbar = {
							"neo-tree",
							"dap-repl",
						},
					},
				},
				winbar = {
					lualine_c = {
						{
							"navic",
							color_correction = "static",
							navic_opts = { highlight = true, separator = " ▶ ", depth_limit = 5 },
						},
					},
					lualine_x = {
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
						{
							"filename",
							path = 1,
							file_status = false,
							color = { fg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "WinBar" }).fg) },
						},
					},
				},
				inactive_winbar = {
					lualine_c = {
						{
							"navic",
							navic_opts = { highlight = false, separator = " ▶ ", depth_limit = 5 },
						},
					},
					lualine_x = {
						{
							"filename",
							path = 1,
							file_status = false,
							color = { fg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "Comment" }).fg) },
						},
					},
				},
				sections = {
					lualine_b = {
						{
							"tabs",
							cond = function()
								return #vim.api.nvim_list_tabpages() > 1
							end,
						},
						{ "buffers" },
					},
					lualine_c = {},
					lualine_x = {
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.search.get,
							cond = require("noice").api.status.search.has,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_y = {
						{
							"branch",
							icon = "",
							color = { bg = "None", fg = "#f5c2e7", gui = "bold" },
						},
					},
					lualine_z = {
						{
							function()
								return dir
							end,
							icon = "󰝰",
							color = { bg = "None", fg = "#94e2d5", gui = "bold" },
						},
						{ "location" },
					},
				},
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = { input = { win_options = { winblend = 0 } } },
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		event = "VeryLazy",
		opts = {
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			cmdline = {
				view = "cmdline",
				format = {
					cmdline = { pattern = "^:", icon = ":", lang = "vim" },
				},
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
		},
		config = function(_, opts)
			vim.opt.showmode = false
			require("noice").setup(opts)
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
