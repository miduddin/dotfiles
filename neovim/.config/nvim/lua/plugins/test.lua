return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-go",
			"olimorris/neotest-phpunit",
		},
		keys = {
			-- stylua: ignore start
			{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
			{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
			{ "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
			{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
			-- stylua: ignore end
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						args = { "-count=1", "-race", "-timeout=10s" },
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
						},
					}),
				},
				icons = {
					failed = "x",
					passed = "o",
					running = "%",
					skipped = "-",
					unknown = "?",
					watching = "w",
				},
				summary = {
					mappings = {
						jumpto = "o",
						output = "O",
					},
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				keys = {
					-- stylua: ignore start
					{ "<leader>du", function() require("dapui").toggle({ reset = true }) end, desc = "Dap UI" },
					{ "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
					-- stylua: ignore end
				},
				opts = {
					icons = { expanded = "🞃", collapsed = "🞂", current_frame = "→" },
					controls = {
						icons = {
							pause = "⏸",
							play = "⯈",
							step_into = "↴",
							step_over = "↷",
							step_out = "↑",
							step_back = "↶",
							run_last = "🗘",
							terminate = "🕱",
							disconnect = "⏻",
						},
					},
					layouts = {
						{
							elements = {
								{ id = "scopes", size = 0.25 },
								{ id = "breakpoints", size = 0.25 },
								{ id = "watches", size = 0.25 },
								{ id = "stacks", size = 0.25 },
							},
							position = "left",
							size = 40,
						},
						{
							elements = {
								{ id = "repl", size = 1 },
							},
							position = "bottom",
							size = 10,
						},
					},
				},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},
			{
				"leoluz/nvim-dap-go",
				dependencies = { "williamboman/mason.nvim" },
				ft = { "go" },
				config = function()
					require("dap-go").setup({})

					vim.api.nvim_create_autocmd("FileType", {
						pattern = { "go" },
						callback = function(ev)
							vim.keymap.set(
								"n",
								"<leader>td",
								"<cmd>lua require('dap-go').debug_test()<CR>",
								{ desc = "Debug nearest (go)", buffer = ev.buf }
							)
						end,
					})
				end,
			},
		},
		keys = {
			-- stylua: ignore start
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
			{ "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>dj", function() require("dap").down() end, desc = "Down" },
			{ "<leader>dk", function() require("dap").up() end, desc = "Up" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
			{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Inspect Value", mode = {"n", "v"} },

			-- Alternative keymaps:
			{ "<F5>", function() require("dap").continue() end, desc = "Continue" },
			{ "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
			-- stylua: ignore end
		},
		config = function()
			local dap = require("dap")
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
					-- xdebugSettings = {
					-- 	max_children = 999,
					-- 	max_depth = 10,
					-- 	max_data = 10240,
					-- },
					-- pathMappings = {
					-- 	["/app"] = "${workspaceFolder}",
					-- },
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "dap-float" },
				callback = function(ev)
					vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = ev.buf })

					vim.api.nvim_create_autocmd({ "WinLeave" }, {
						buffer = ev.buf,
						command = "q",
					})
				end,
			})
		end,
	},
}
