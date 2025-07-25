return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"fredrikaverpil/neotest-golang",
			{ "miduddin/neotest-phpunit", branch = "dev" },
		},
		keys = {
			-- stylua: ignore start
			{ "<Leader>td", function() require("neotest").run.run({ strategy = "dap", suite = false }) end, desc = "Debug Nearest" },
			{ "<Leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
			{ "<Leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
			{ "<Leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
			{ "<Leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
			{ "<Leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
			{ "<Leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
			{ "<Leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
			-- stylua: ignore end
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-golang")({
						go_test_args = { "-count=1", "-timeout=10s" },
					}),
					require("neotest-phpunit")({
						env = {
							XDEBUG_CONFIG = "idekey=neotest",
						},
						filter_dirs = { ".git", "node_modules", "vendor" },
						dap = {
							type = "php",
							request = "launch",
							name = "Listen for Xdebug",
							port = 9003,
							xdebugSettings = {
								max_children = 512,
								max_data = 10240,
								max_depth = 4,
							},
						},
					}),
				},
				discovery = {
					enabled = false,
					concurrent = 1,
				},
				icons = { unknown = "?" },
				log_level = vim.g.log_level,
				quickfix = { enabled = false },
				summary = {
					mappings = {
						jumpto = "o",
						output = "O",
					},
				},
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "neotest-summary" },
				callback = function(ev) vim.keymap.set("n", "q", neotest.summary.close, { buffer = ev.buf }) end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "neotest-output" },
				callback = function(ev) vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = ev.buf }) end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = { "leoluz/nvim-dap-go" },
		keys = {
			{
				"<Leader>dB",
				function()
					vim.ui.input({ prompt = "Breakpoint condition" }, function(input)
						if input ~= nil then require("dap").set_breakpoint(input) end
					end)
				end,
				desc = "Breakpoint Condition",
			},
			{ "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
			{ "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<Leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<Leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
			{ "<Leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<Leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<Leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

			-- Alternative keymaps:
			{ "<F5>", function() require("dap").continue() end, desc = "Continue" },
			{ "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
		},
		config = function()
			require("dap-go").setup()

			local dap = require("dap")
			dap.set_log_level("ERROR")

			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
			}
			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug",
					port = 9003,
					xdebugSettings = {
						max_children = 512,
						max_data = 10240,
						max_depth = 4,
					},
				},
			}

			local widgets = require("dap.ui.widgets")
			local scopes = widgets.sidebar(widgets.scopes, nil, "split")
			vim.keymap.set({ "n", "v" }, "<Leader>dw", widgets.hover)
			vim.keymap.set("n", "<Leader>ds", scopes.toggle)
		end,
	},
}
