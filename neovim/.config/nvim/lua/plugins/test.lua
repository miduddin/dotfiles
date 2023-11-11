return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-go",
		},
		keys = {
			-- stylua: ignore start
			{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
			{ "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
			{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
			-- stylua: ignore end
		},
		opts = {
			status = { virtual_text = true },
			output = { open_on_run = true },
			quickfix = {
				open = function()
					vim.cmd("Trouble quickfix")
				end,
			},
			adapters = {
				["neotest-go"] = { args = { "-count=1", "-race" } },
			},
		},
		config = function(_, opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif meta and meta.__call then
								adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			require("neotest").setup(opts)
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
				opts = {},
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
				keys = {
					{ "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug nearest (go)" },
				},
				opts = {},
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
			{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
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
					pathMappings = {
						["/app"] = "${workspaceFolder}",
					},
					xdebugSettings = {
						max_children = 999,
						max_depth = 10,
						max_data = 10240,
					},
				},
			}

			local icons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = { " ", "DiagnosticError" },
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end
		end,
	},
}
