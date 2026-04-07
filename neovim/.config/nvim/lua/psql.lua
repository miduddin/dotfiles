local M = {}

---@param pg_service string
---@param timeout_s integer?
function M.query_paragraph(pg_service, timeout_s)
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

	local obj = vim.system({ "psql", "service=" .. pg_service }, {
		stdin = table.concat(input, "\n"),
		text = true,
		timeout = timeout_ms,
	})

	utils.write_cmd_output_to_split(obj, string.format("[%s] Query result - %s", pg_service, os.date("%T")))
end

return M
