return {
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<Leader>gd",
				function()
					local ref = vim.fn.input({ prompt = "Compare with ref: ", cancelreturn = ".." })
					if ref ~= ".." then
						vim.cmd("DiffviewOpen " .. ref)
					end
				end,
				desc = "Diff with ref...",
			},
			{ "<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>", desc = "Current file history" },
			{ "<Leader>gl", ":DiffviewFileHistory<CR>", desc = "Selected lines history", mode = "v" },
			{ "<Leader>gL", "<Cmd>DiffviewFileHistory<CR>", desc = "Project history" },
		},
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
			keymaps = {
				file_history_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				file_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				view = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
			},
		},
	},
	{
		"miduddin/openingh.nvim",
		branch = "dev",
		keys = {
			{ "<Leader>gof", "<Cmd>OpenInGHFileLines<CR>", desc = "Open file in browser", mode = { "n", "v" } },
		},
	},
	{
		"echasnovski/mini.diff",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.diff").setup({
				view = {
					priority = 1,
					style = "sign",
					signs = { add = "┃", change = "┃", delete = "_" },
				},
			})
		end,
	},
}
