-- git-blame.nvim config
vim.g.gitblame_enabled = 0

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
				desc = "Diff with ref",
			},
		},
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
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
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame_opts = {
				delay = 0,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <abbrev_sha> <summary>",
			preview_config = {
				border = "rounded",
			},
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
				-- stylua: ignore start
				map("n", "]h", function() gs.next_hunk({preview = true}) end, "Next Hunk")
				map("n", "[h", function() gs.prev_hunk({preview = true}) end, "Prev Hunk")
				map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
				map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
				-- stylua: ignore end
			end,
		},
	},
}
