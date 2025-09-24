require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			node_decremental = "<BS>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aa"] = { query = "@parameter.outer", desc = "Select around arg" },
				["ia"] = { query = "@parameter.inner", desc = "Select within arg" },
				["af"] = { query = "@function.outer", desc = "Select around function" },
				["if"] = { query = "@function.inner", desc = "Select within function" },
				["ac"] = { query = "@class.outer", desc = "Select around class" },
				["ic"] = { query = "@class.inner", desc = "Select within class" },
				["ab"] = { query = "@block.outer", desc = "Select around block" },
				["ib"] = { query = "@block.inner", desc = "Select within block" },
			},
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
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]a"] = { query = "@parameter.inner", desc = "Next arg start" },
				["]f"] = { query = "@function.outer", desc = "Next function start" },
			},
			goto_next_end = {
				["]A"] = { query = "@parameter.inner", desc = "Next arg end" },
				["]F"] = { query = "@function.outer", desc = "Next function end" },
			},
			goto_previous_start = {
				["[a"] = { query = "@parameter.inner", desc = "Prev arg start" },
				["[f"] = { query = "@function.outer", desc = "Prev function start" },
			},
			goto_previous_end = {
				["[A"] = { query = "@parameter.inner", desc = "Prev arg end" },
				["[F"] = { query = "@function.outer", desc = "Prev function end" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<Leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<Leader>A"] = "@parameter.inner",
			},
		},
	},
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
Map(",", ts_repeat_move.repeat_last_move_opposite, { "n", "x", "o" })
Map(";", ts_repeat_move.repeat_last_move, { "n", "x", "o" })
Map("f", ts_repeat_move.builtin_f_expr, { "n", "x", "o" }, { expr = true })
Map("F", ts_repeat_move.builtin_F_expr, { "n", "x", "o" }, { expr = true })
Map("t", ts_repeat_move.builtin_t_expr, { "n", "x", "o" }, { expr = true })
Map("T", ts_repeat_move.builtin_T_expr, { "n", "x", "o" }, { expr = true })

require("treesitter-context").setup({ max_lines = 2, multiwindow = true })
