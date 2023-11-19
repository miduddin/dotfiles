return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			toggler = { line = "<C-_>" },
			opleader = { line = "<C-_>" },
		},
	},
	{
		"mg979/vim-visual-multi",
		event = { "BufReadPost", "BufNewFile" },
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-x>",
				["Find Subword Under"] = "<C-x>",
			}
		end,
	},
	{
		"kylechui/nvim-surround",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
}
