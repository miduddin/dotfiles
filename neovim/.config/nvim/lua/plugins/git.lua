return {
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>gd",
				function()
					local ref = vim.fn.input({ prompt = "Compare with ref: ", cancelreturn = ".." })
					if ref ~= ".." then
						vim.cmd("DiffviewOpen " .. ref)
					end
				end,
				desc = "Diff with ref...",
			},
			{ "<leader>gl", "<Cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
			{ "<leader>gl", ":DiffviewFileHistory<cr>", desc = "Selected lines history", mode = "v" },
			{ "<leader>gL", "<Cmd>DiffviewFileHistory<cr>", desc = "Project history" },
		},
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
			keymaps = {
				file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
				file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
				view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
			},
		},
	},
	{
		"miduddin/openingh.nvim",
		branch = "dev",
		keys = {
			{ "<leader>gof", "<cmd>OpenInGHFileLines<cr>", desc = "Open file in browser", mode = { "n", "v" } },
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
