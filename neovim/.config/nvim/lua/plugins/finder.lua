return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<Leader><Space>", "<Cmd>FzfLua files<CR>", desc = "Find files" },
			{ "<M-b>", "<Cmd>FzfLua buffers<CR>", desc = "Open buffers" },
			{ "<Leader>fb", "<Cmd>FzfLua git_branches<CR>", desc = "Git branches" },
			{ "<Leader>fc", "<Cmd>FzfLua blines<CR>", desc = "Current buffer fuzzy find" },
			{ "<Leader>ff", "<Cmd>FzfLua git_bcommits<CR>", desc = "File history" },
			{ "<Leader>fg", "<Cmd>FzfLua live_grep<CR>", desc = "Live grep" },
			{ "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", desc = "Help pages" },
			{ "<Leader>fk", "<Cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
			{ "<Leader>fr", "<Cmd>FzfLua resume<CR>", desc = "Resume last search" },
			{ "<Leader>fs", "<Cmd>FzfLua lsp_document_symbols<CR>", desc = "Symbols (document)" },
			{ "<Leader>fw", "<Cmd>FzfLua grep_cword<CR>", desc = "Find word under cursor" },
			{ "<Leader>fw", "<Cmd>FzfLua grep_visual<CR>", desc = "Find selected text", mode = { "v" } },
			{ "<Leader>f<tab>", "<Cmd>FzfLua tabs<CR>", desc = "List tabs" },
		},
		opts = {
			winopts = {
				preview = {
					delay = 0,
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
						["enter"] = function(selected)
							vim.cmd("DiffviewOpen " .. selected[1])
						end,
					},
				},
			},
		},
		config = function(_, opts)
			require("fzf-lua").setup(opts)
			vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
			vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "NormalFloat" })
			vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "FloatTitle" })
			vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { link = "Normal" })
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = {
				winblend = 0,
			},
		},
		config = function(_, opts)
			require("bqf").setup(opts)
			vim.api.nvim_set_hl(0, "BqfPreviewFloat", { link = "NormalFloat" })
			vim.api.nvim_set_hl(0, "BqfPreviewTitle", { link = "FloatTitle" })
		end,
	},
}
