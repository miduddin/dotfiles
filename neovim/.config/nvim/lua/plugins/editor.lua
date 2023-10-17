return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-x>",
				["Find Subword Under"] = "<C-x>",
			}
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
}
