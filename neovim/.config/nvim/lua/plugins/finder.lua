return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<M-b>", "<cmd>FzfLua buffers<cr>", desc = "Open buffers" },
			{ "<leader>fb", "<cmd>FzfLua git_branches<cr>", desc = "Git branches" },
			{ "<leader>fc", "<cmd>FzfLua blines<cr>", desc = "Current buffer fuzzy find" },
			{ "<leader>ff", "<cmd>FzfLua git_bcommits<cr>", desc = "File history" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help pages" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume last search" },
			{ "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbols (document)" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
			{ "<leader>fw", "<cmd>FzfLua grep_visual<cr>", desc = "Find selected text", mode = { "v" } },
			{ "<leader>f<tab>", "<cmd>FzfLua tabs<cr>", desc = "List tabs" },
		},
		opts = {
			winopts = {
				preview = {
					delay = 50,
					layout = "vertical",
					vertical = "down:75%",
				},
			},
			files = {
				fd_opts = "--color=never --type f --hidden --follow "
					.. "--exclude .git/ --exclude node_modules/ --exclude vendor/",
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --hidden "
					.. "--color=always --smart-case --max-columns=4096 "
					.. "-g '!.git/' -g '!node_modules/' -g '!vendor/' -e",
			},
			git = {
				branches = {
					actions = {
						["default"] = function(selected)
							vim.cmd("DiffviewOpen " .. selected[1])
						end,
					},
				},
			},
			lsp = {
				symbols = {
					symbol_style = 3,
				},
			},
		},
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Diagnostics (workspace)" },
			{ "<leader>xx", "<cmd>Trouble document_diagnostics<cr>", desc = "Diagnostics (document)" },
			{ "<leader>xq", "<cmd>cclose|Trouble quickfix<cr>", desc = "Quickfix" },
			{ "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "Loclist" },
			{ "gr", "<cmd>Trouble lsp_references<cr>", desc = "LSP references" },
			{ "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "LSP definitions" },
			{ "gD", "<cmd>Trouble lsp_type_definitions<cr>", desc = "LSP type definitions" },
			{ "gi", "<cmd>Trouble lsp_implementations<cr>", desc = "LSP implementations" },
			{
				"]t",
				[[<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>]],
				desc = "Next trouble item",
			},
			{
				"[t",
				[[<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<cr>]],
				desc = "Previous trouble item",
			},
		},
		config = function()
			require("trouble").setup({
				icons = false,
				include_declaration = {},
				fold_open = "-",
				fold_closed = "+",
				indent_lines = false,
				signs = {
					error = "E",
					warning = "W",
					hint = "H",
					information = "I",
				},
				use_diagnostic_signs = false,
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "Trouble" },
				command = [[setlocal cursorlineopt=line]],
			})
		end,
	},
}
