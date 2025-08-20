require("diffview").setup({
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
	use_icons = false,
	signs = {
		fold_closed = "+ ",
		fold_open = "- ",
	},
})

local function compare_with_ref()
	local ref = vim.fn.input({ prompt = "Compare with ref: ", cancelreturn = ".." })
	if ref ~= ".." then vim.cmd("DiffviewOpen " .. ref) end
end

Map("<Leader>gc", compare_with_ref, "n", { desc = "Git: compare with ref..." })
Map("<Leader>gl", ":DiffviewFileHistory<CR>", "v", { desc = "Git: selected lines log" })
Map("<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>", "n", { desc = "Git: file log" })
Map("<Leader>gL", "<Cmd>DiffviewFileHistory<CR>", "n", { desc = "Git: project log" })
