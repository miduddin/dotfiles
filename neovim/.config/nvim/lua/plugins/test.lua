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

vim.keymap.set("n", "<Leader>td", function() neotest.run.run({ strategy = "dap", suite = false }) end)
vim.keymap.set("n", "<Leader>tr", neotest.run.run)
vim.keymap.set("n", "<Leader>ts", neotest.summary.toggle)
vim.keymap.set("n", "<Leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end)
vim.keymap.set("n", "<Leader>tO", neotest.output_panel.toggle)
vim.keymap.set("n", "<Leader>tS", neotest.run.stop)

require("dap-go").setup()

local dap = require("dap")
dap.set_log_level("ERROR")

local widgets = require("dap.ui.widgets")
local scopes = widgets.sidebar(widgets.scopes, nil, "split")
vim.keymap.set({ "n", "v" }, "<Leader>dw", widgets.hover)
vim.keymap.set("n", "<Leader>ds", scopes.toggle)

vim.keymap.set("n", "<Leader>dB", function()
	vim.ui.input({ prompt = "Breakpoint condition" }, function(input)
		if input ~= nil then dap.set_breakpoint(input) end
	end)
end, { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<Leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Run Last" })
vim.keymap.set("n", "<Leader>dn", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Terminate" })

-- Alternative keymaps:
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
