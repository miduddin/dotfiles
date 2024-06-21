return {
	{
		"echasnovski/mini.clue",
		event = "VeryLazy",
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
					-- Leader triggers
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				indent = {
					enable = true,
					disable = { "yaml" },
				},
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize_bytes = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize_bytes then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				ensure_installed = {
					"bash",
					"c",
					"dockerfile",
					"go",
					"gomod",
					"gosum",
					"html",
					"http",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"php",
					"printf",
					"query",
					"rust",
					"sql",
					"terraform",
					"toml",
					"vim",
					"vimdoc",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						node_decremental = "<bs>",
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
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			vim.filetype.add({
				pattern = {
					[".*%.blade%.php"] = "blade",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
	},
	{
		"folke/persistence.nvim",
		keys = {
			{ "<leader>sl", [[<cmd>lua require("persistence").load()<cr>]], desc = "Load session" },
		},
		event = "BufReadPre",
		opts = {},
	},
}
