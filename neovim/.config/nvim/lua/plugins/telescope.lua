return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		keys = {
			{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
			{ "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current buffer fuzzy find" },
			{ "<leader>ff", "<cmd>Telescope git_bcommits<cr>", desc = "File history" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols (document)" },
			{ "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Symbols (workspace)" },
			{ "<leader>ft", "<cmd>Telescope git_status<cr>", desc = "Git status" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word under cursor" },
		},
		config = function()
			local trouble = require("trouble.providers.telescope")
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { "%.git/", "node_modules/", "vendor/" },
					results_title = false,
					layout_strategy = "center",
					layout_config = {
						mirror = true,
						prompt_position = "top",
						anchor = "N",
						preview_cutoff = 1,

						width = function(_, max_columns, _)
							return math.min(max_columns, 100)
						end,

						height = function(_, _, max_lines)
							return math.min(max_lines, 15)
						end,
					},
					borderchars = {
						prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
						results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
						preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					},
					sorting_strategy = "ascending",
					mappings = {
						i = { ["<c-t>"] = trouble.open_with_trouble },
						n = { ["<c-t>"] = trouble.open_with_trouble },
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						no_ignore = true,
					},
					lsp_document_symbols = {
						symbol_width = 50,
					},
					live_grep = {
						additional_args = { "-.", "-g", "!.git/" },
					},
					git_bcommits = {
						git_command = { "git", "log", "--pretty=reference", "--follow" },
					},
					git_branches = {
						mappings = {
							i = {
								["<C-d>"] = function(bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									require("telescope.actions").close(bufnr)
									vim.cmd("DiffviewOpen " .. selection.value)
								end,
							},
							n = {
								["<C-d>"] = function(bufnr)
									local selection = require("telescope.actions.state").get_selected_entry()
									require("telescope.actions").close(bufnr)
									vim.cmd("DiffviewOpen " .. selection.value)
								end,
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			require("telescope").load_extension("fzf")

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = { "TelescopePreviewerLoaded" },
				command = [[setlocal number]],
			})
		end,
	},
	{
		"folke/trouble.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Diagnostics (workspace)" },
			{ "<leader>xx", "<cmd>Trouble document_diagnostics<cr>", desc = "Diagnostics (document)" },
			{ "<leader>xq", "<cmd>Trouble quickfix<cr>", desc = "Quickfix" },
			{ "<leader>xl", "<cmd>Trouble loclist<cr>", desc = "Loclist" },
			{ "gr", "<cmd>Trouble lsp_references<cr>", desc = "LSP references" },
			{ "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "LSP definitions" },
			{ "gD", "<cmd>Trouble lsp_type_definitions<cr>", desc = "LSP type definitions" },
			{ "gi", "<cmd>Trouble lsp_implementations<cr>", desc = "LSP implementations" },
		},
	},
}
