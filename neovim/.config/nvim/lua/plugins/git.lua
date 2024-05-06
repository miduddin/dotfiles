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
		"f-person/git-blame.nvim",
		cmd = {
			"GitBlameOpenCommitURL",
			"GitBlameOpenFileURL",
		},
		keys = {
			{ "<leader>goc", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open commit in browser", mode = "n" },
			{ "<leader>gof", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open file in browser", mode = "n" },
		},
		opts = {
			enabled = false,
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame_opts = { delay = 0 },
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <abbrev_sha> <summary>",
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<leader>hs", gs.stage_hunk)
				map("n", "<leader>hr", gs.reset_hunk)
				map("n", "<leader>hS", gs.stage_buffer)
				map("n", "<leader>hu", gs.undo_stage_hunk)
				map("n", "<leader>hR", gs.reset_buffer)
				map("n", "<leader>hp", gs.preview_hunk)
				map("n", "<leader>hd", gs.toggle_deleted)
				-- stylua: ignore start
				map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
				map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
				map("n", "<leader>hD", function() gs.diffthis("~") end)
				map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
				-- stylua: ignore end

				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}
