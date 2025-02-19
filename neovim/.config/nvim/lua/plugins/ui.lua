return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<Leader>e", "<Cmd>Oil<CR>", desc = "File explorer" },
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
		config = function(_, opts)
			require("oil").setup(opts)
			vim.api.nvim_set_hl(0, "OilDirHidden", { link = "OilDir" })
			vim.api.nvim_set_hl(0, "OilSocketHidden", { link = "OilSocket" })
			vim.api.nvim_set_hl(0, "OilLinkHidden", { link = "OilLink" })
			vim.api.nvim_set_hl(0, "OilOrphanLinkHidden", { link = "OilOrphanLink" })
			vim.api.nvim_set_hl(0, "OilLinkTargetHidden", { link = "OilLinkTarget" })
			vim.api.nvim_set_hl(0, "OilOrphanLinkTargetHidden", { link = "OilOrphanLinkTarget" })
			vim.api.nvim_set_hl(0, "OilFileHidden", { link = "OilFile" })
		end,
	},
	{
		"echasnovski/mini.tabline",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("mini.tabline").setup(opts)
			vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "StFilename" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { link = "MiniTablineCurrent" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { link = "MiniTablineVisible" })
			vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { link = "MiniTablineHidden" })
		end,
	},
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		opts = { opts = { number = true } },
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
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Leader>ba", "<Cmd>lua Snacks.bufdelete.all()<CR>", desc = "Close all buffers" },
			{ "<Leader>bd", "<Cmd>lua Snacks.bufdelete.delete()<CR>", desc = "Close current buffer" },
			{ "<Leader>bo", "<Cmd>lua Snacks.bufdelete.other()<CR>", desc = "Close other buffers" },
			{ "<Leader>gof", "<Cmd>lua Snacks.gitbrowse.open()<CR>", desc = "Open in git web", mode = { "n", "v" } },
		},
		opts = {
			gitbrowse = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			picker = { enabled = true },

			styles = {
				input = {
					relative = "cursor",
					row = -3,
					col = 0,
					width = 30,
					keys = {
						i_esc = false,
					},
				},
			},
		},
	},
	-- {
	-- 	"NStefan002/screenkey.nvim",
	-- 	cmd = { "Screenkey" },
	-- 	opts = {
	-- 		win_opts = { title = "Input" },
	-- 	},
	-- },
	-- { "norcalli/nvim-colorizer.lua", cmd = { "ColorizerToggle" } },
}
