local M = {}

---@param connection_name string
---@param timeout_s integer?
function M.query_paragraph(connection_name, timeout_s)
	local utils = require("utils")
	local timeout_ms = (timeout_s or 3) * 1000

	local input = {
		"\\set QUIET 1",
		"\\pset columns " .. (vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff),
		"\\timing on",
		"\\set QUIET 0",
	}
	for _, v in pairs(utils.get_current_paragraph()) do
		table.insert(input, v)
	end

	local obj = vim.system({ "usql", connection_name }, {
		stdin = table.concat(input, "\n"),
		text = true,
		timeout = timeout_ms,
	})

	utils.write_cmd_output_to_split(obj, string.format("[%s] Query result - %s", connection_name, os.date("%T")))
end

return M
