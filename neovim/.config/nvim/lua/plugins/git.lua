return {
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<Leader>gd",
				function()
					local ref = vim.fn.input({ prompt = "Compare with ref: ", cancelreturn = ".." })
					if ref ~= ".." then vim.cmd("DiffviewOpen " .. ref) end
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
			file_panel = {
				win_config = { win_opts = { cursorline = true, cursorlineopt = "both" } },
			},
			file_history_panel = {
				win_config = { win_opts = { cursorline = true, cursorlineopt = "both" } },
			},
			enhanced_diff_hl = true,
			hooks = {
				diff_buf_win_enter = function(_, _, ctx)
					if ctx.layout_name:match("^diff3") then vim.opt_local.winhl = "DiffDelete:DiffviewDiffDeleteDim" end
				end,
			},
			keymaps = {
				file_history_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				file_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				view = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
			},
		},
	},
}
