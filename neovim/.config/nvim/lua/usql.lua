local M = {}

---@param connection_name string
function M.query_paragraph(connection_name)
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
		string.format("[%s] Query result - %s", connection_name, os.date("%T")),
		{ "usql", connection_name },
		input
	)
end

return M
