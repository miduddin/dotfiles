local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-golang")({
			go_test_args = { "-count=1", "-timeout=10s" },
		}),
	},
	discovery = {
		enabled = false,
		concurrent = 1,
	},
	icons = {
		unknown = "?",
		child_indent = "  ",
		child_prefix = " ",
		collapsed = "+",
		expanded = "-",
		final_child_indent = "  ",
		final_child_prefix = " ",
		non_collapsible = " ",
	},
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
	callback = function(ev) Map("q", neotest.summary.close, "n", { buffer = ev.buf }) end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "neotest-output" },
	callback = function(ev) Map("q", "<Cmd>q<CR>", "n", { buffer = ev.buf }) end,
})

local function debug_nearest_test() neotest.run.run({ strategy = "dap", suite = false }) end
local function toggle_test_output() neotest.output.open({ enter = true, auto_close = true }) end

Map("<Leader>td", debug_nearest_test, "n", { desc = "Test: debug nearest" })
Map("<Leader>tO", neotest.output_panel.toggle, "n", { desc = "Test: toggle output panel" })
Map("<Leader>to", toggle_test_output, "n", { desc = "Test: toggle output" })
Map("<Leader>tr", neotest.run.run, "n", { desc = "Test: run nearest test" })
Map("<Leader>ts", neotest.summary.toggle, "n", { desc = "Test: toggle summary view" })
Map("<Leader>tt", neotest.run.stop, "n", { desc = "Test: stop" })

require("dap-go").setup()

local dap = require("dap")
dap.set_log_level("ERROR")

local widgets = require("dap.ui.widgets")
local scopes = widgets.sidebar(widgets.scopes, nil, "split")

local function breakpoint_condition()
	vim.ui.input({ prompt = "Breakpoint condition" }, function(input)
		if input ~= nil then dap.set_breakpoint(input) end
	end)
end

Map("<F10>", dap.step_over, "n", { desc = "Debug: step over" })
Map("<F11>", dap.step_into, "n", { desc = "Debug: step into" })
Map("<F12>", dap.step_out, "n", { desc = "Debug: step out" })
Map("<F5>", dap.continue, "n", { desc = "Debug: continue" })
Map("<Leader>dB", breakpoint_condition, "n", { desc = "Debug: add breakpoint with condition" })
Map("<Leader>db", dap.toggle_breakpoint, "n", { desc = "Debug: toggle breakpoint" })
Map("<Leader>dc", dap.continue, "n", { desc = "Debug: continue" })
Map("<Leader>dC", dap.run_to_cursor, "n", { desc = "Debug: run to cursor" })
Map("<Leader>di", dap.step_into, "n", { desc = "Debug: step into" })
Map("<Leader>dl", dap.run_last, "n", { desc = "Debug: run last debugging session" })
Map("<Leader>dn", dap.step_over, "n", { desc = "Debug: step over" })
Map("<Leader>do", dap.step_out, "n", { desc = "Debug: step out" })
Map("<Leader>ds", scopes.toggle, "n", { desc = "Debug: toggle scope view" })
Map("<Leader>dt", dap.terminate, "n", { desc = "Debug: terminate session" })
Map("<Leader>dw", widgets.hover, { "n", "v" }, { desc = "Debug: hover widget" })
