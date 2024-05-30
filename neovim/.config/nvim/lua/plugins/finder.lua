return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
			defaults = {
				formatter = "path.filename_first",
			},
			file_icon_padding = " ",
			files = {
				fd_opts = "--color=never --type f --hidden --follow "
					.. "--exclude .git/ --exclude node_modules/ --exclude vendor/",
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --hidden --multiline "
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
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
			{ "<leader>xq", "<cmd>cclose|Trouble qflist toggle<cr>", desc = "Quickfix" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist" },
			{ "gr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references" },
			{ "gd", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "LSP definitions" },
			{ "gD", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "LSP type definitions" },
			{ "gi", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "LSP implementations" },
			{ "]t", [[<cmd>lua require("trouble").next()<cr>]], desc = "Next trouble item" },
			{ "[t", [[<cmd>lua require("trouble").prev()<cr>]], desc = "Previous trouble item" },
		},
		opts = {
			focus = true,
			throttle = { preview = { ms = 0 } },
		},
	},
}
