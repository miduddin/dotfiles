local ts = require("nvim-treesitter")
local all = ts.get_available()

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = args.match
		-- html causes neovim to segfault.
		if ft == "html" or not vim.list_contains(all, ft) then return end
		ts.install({ ft })
		vim.treesitter.start()
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.inner"] = "v",
			["@parameter.outer"] = "v",
			["@function.inner"] = "V",
			["@function.outer"] = "V",
			["@class.inner"] = "V",
			["@class.outer"] = "V",
			["@block.inner"] = "v",
			["@block.outer"] = "V",
		},
	},
	move = {
		set_jumps = true,
	},
})

local ts_select = require("nvim-treesitter-textobjects.select").select_textobject
Map("aa", function() ts_select("@parameter.outer", "textobjects") end, { "x", "o" })
Map("ia", function() ts_select("@parameter.inner", "textobjects") end, { "x", "o" })
Map("af", function() ts_select("@function.outer", "textobjects") end, { "x", "o" })
Map("if", function() ts_select("@function.inner", "textobjects") end, { "x", "o" })
Map("ac", function() ts_select("@class.outer", "textobjects") end, { "x", "o" })
Map("ic", function() ts_select("@class.inner", "textobjects") end, { "x", "o" })
Map("ab", function() ts_select("@block.outer", "textobjects") end, { "x", "o" })
Map("ib", function() ts_select("@block.inner", "textobjects") end, { "x", "o" })

local ts_swap = require("nvim-treesitter-textobjects.swap")
Map("<Leader>a", function() ts_swap.swap_next("@parameter.inner") end, "n")
Map("<Leader>A", function() ts_swap.swap_previous("@parameter.inner") end, "n")

local ts_move = require("nvim-treesitter-textobjects.move")
Map("]a", function() ts_move.goto_next_start("@parameter.outer", "textobjects") end, { "n", "x", "o" })
Map("]A", function() ts_move.goto_next_end("@parameter.outer", "textobjects") end, { "n", "x", "o" })
Map("[a", function() ts_move.goto_previous_start("@parameter.outer", "textobjects") end, { "n", "x", "o" })
Map("[A", function() ts_move.goto_previous_end("@parameter.outer", "textobjects") end, { "n", "x", "o" })
Map("]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end, { "n", "x", "o" })
Map("]F", function() ts_move.goto_next_end("@function.outer", "textobjects") end, { "n", "x", "o" })
Map("[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { "n", "x", "o" })
Map("[F", function() ts_move.goto_previous_end("@function.outer", "textobjects") end, { "n", "x", "o" })

local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
Map(",", ts_repeat_move.repeat_last_move_opposite, { "n", "x", "o" })
Map(";", ts_repeat_move.repeat_last_move, { "n", "x", "o" })
Map("f", ts_repeat_move.builtin_f_expr, { "n", "x", "o" }, { expr = true })
Map("F", ts_repeat_move.builtin_F_expr, { "n", "x", "o" }, { expr = true })
Map("t", ts_repeat_move.builtin_t_expr, { "n", "x", "o" }, { expr = true })
Map("T", ts_repeat_move.builtin_T_expr, { "n", "x", "o" }, { expr = true })

require("treesitter-context").setup({ max_lines = 2, multiwindow = true })
