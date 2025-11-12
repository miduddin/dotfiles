local ts = require("nvim-treesitter")
local supported_types = ts.get_available()

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function(args)
		local ft = args.match
		if not vim.tbl_contains(supported_types, ft) then return end
		ts.install({ ft })
		vim.treesitter.start()
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.inner"] = "V",
			["@function.outer"] = "V",
		},
		include_surrounding_whitespace = false,
	},
	move = {
		set_jumps = true,
	},
})

local ts_select = require("nvim-treesitter-textobjects.select").select_textobject
vim.keymap.set({ "x", "o" }, "af", function() ts_select("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() ts_select("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "aa", function() ts_select("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() ts_select("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ab", function() ts_select("@block.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ib", function() ts_select("@block.inner", "textobjects") end)

local ts_swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.inner") end)

local ts_move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]F", function() ts_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[F", function() ts_move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]a", function() ts_move.goto_next_start("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[a", function() ts_move.goto_previous_start("@parameter.inner", "textobjects") end)

local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

require("treesitter-context").setup({ max_lines = 2, multiwindow = true })
