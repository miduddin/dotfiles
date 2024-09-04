local utils = require("src.utils")
local M = {}

---@param query string[]
---@param pg_service string
---@param timeout_s integer?
local function run_query(query, pg_service, timeout_s)
	local timeout_ms = (timeout_s or 3) * 1000

	local input = {
		"\\set QUIET 1",
		"\\pset columns " .. (vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff),
		"set statement_timeout to " .. timeout_ms .. ";",
		"\\timing on",
		"\\set QUIET 0",
	}
	for _, v in pairs(query) do
		table.insert(input, v)
	end

	local obj = vim.system({ "psql", "service=" .. pg_service }, {
		env = { PGCONNECT_TIMEOUT = timeout_ms },
		stdin = table.concat(input, "\n"),
		text = true,
		timeout = timeout_ms,
	})

	utils.write_cmd_output_to_split(obj, string.format("[%s] Query result - %s", pg_service, os.date("%T")))
end

---@param pg_service string
---@param timeout_s integer?
function M.query_paragraph(pg_service, timeout_s)
	local query_begin = vim.api.nvim_buf_get_mark(0, "(")[1]
	local query_end = vim.api.nvim_buf_get_mark(0, ")")[1]

	local query = vim.api.nvim_buf_get_lines(0, query_begin - 1, query_end, false)

	run_query(query, pg_service, timeout_s)
end

return M
