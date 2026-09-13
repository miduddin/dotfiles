local dap = require("dap")
dap.set_log_level("ERROR")
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "Removed" })
vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "Removed" })
vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "Removed" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Removed", linehl = "DiffDelete" })

dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:" .. "${port}" },
	},
	options = {
		initialize_timeout_sec = 10,
	},
}

dap.adapters.ruby = {
	type = "server",
	host = vim.env.RUBY_DEBUG_HOST or "127.0.0.1",
	port = "38698",
}
dap.configurations.ruby = {
	{
		type = "ruby",
		name = "Attach to rdbg (port 38698)",
		request = "attach",
		options = { source_filetype = "ruby" },
		error_on_failure = true,
		localfs = true,
		port = 38698,
		waiting = 0,
	},
}

local widgets = require("dap.ui.widgets")

local hl_stl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
local hl_norm = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
local hl_warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
dap.listeners.after["event_process"]["my"] = function()
	vim.api.nvim_set_hl(0, "StatusLine", { bg = hl_warn.fg, fg = hl_norm.bg, update = true })
end
dap.listeners.after["event_terminated"]["my"] = function()
	vim.api.nvim_set_hl(0, "StatusLine", { bg = hl_stl.bg, fg = hl_stl.fg, update = true })
end

local function breakpoint_condition()
	vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
		if input ~= nil then dap.set_breakpoint(input) end
	end)
end

Map("<F10>", dap.step_over, "n", { desc = "Debug: step over" })
Map("<F11>", dap.step_into, "n", { desc = "Debug: step into" })
Map("<F12>", dap.step_out, "n", { desc = "Debug: step out" })
Map("<F5>", dap.continue, "n", { desc = "Debug: continue" })
Map("<Leader>dB", breakpoint_condition, "n", { desc = "Debug: add breakpoint with condition" })
Map("<Leader>db", dap.toggle_breakpoint, "n", { desc = "Debug: toggle breakpoint" })
Map("<Leader>dC", dap.run_to_cursor, "n", { desc = "Debug: run to cursor" })
Map("<Leader>dl", dap.run_last, "n", { desc = "Debug: run last debugging session" })
Map("<Leader>dt", dap.terminate, "n", { desc = "Debug: terminate session" })
Map("<Leader>dw", widgets.hover, { "n", "v" }, { desc = "Debug: hover widget" })

local dap_view = require("dap-view")
dap_view.setup({ auto_toggle = true })

Map("<Leader>dp", dap_view.toggle, "n", { desc = "Debug: toggle debug panel" })
