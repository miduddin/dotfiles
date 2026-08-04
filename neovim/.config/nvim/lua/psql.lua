local M = {}

---@param pg_service string
function M.query_paragraph(pg_service)
	local utils = require("utils")

	local input = {
		"\\set QUIET 1",
		"\\pset columns " .. (vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff),
		"\\timing on",
		"\\set QUIET 0",
	}
	for _, v in pairs(utils.get_current_paragraph()) do
		table.insert(input, v)
	end

	utils.write_cmd_output_to_split(
		string.format("Query result", pg_service),
		{ "psql", "service=" .. pg_service },
		input
	)
end

return M
