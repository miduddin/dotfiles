local M = {}

---@param obj vim.SystemObj
---@param bufname string
function M.write_cmd_output_to_split(obj, bufname)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, bufname)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	Map("q", "<Cmd>bd<CR>", "n", { desc = "Close buffer", buffer = buf })

	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "Running..." })
	vim.cmd("redraw")

	local result = obj:wait()

	local text = {}
	for _, line in pairs(vim.fn.split(result.stdout, "\n")) do
		table.insert(text, line)
	end
	if result.stderr then
		if result.code == 124 then
			table.insert(text, "Error: command timed out.")
		else
			table.insert(text, "")
			for _, line in pairs(vim.fn.split(result.stderr, "\n")) do
				table.insert(text, line)
			end
		end
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, true, text)
end

---@param bufnr integer
---@param linenr integer 1-based line number.
local function get_line_text(bufnr, linenr) return vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1] end

---@return string[]
function M.get_current_paragraph()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	assert(vim.trim(get_line_text(0, current_line)) ~= "", "Current line is empty!")

	local line_count = vim.api.nvim_buf_line_count(0)

	local start_line = current_line
	while start_line > 1 do
		if vim.trim(get_line_text(0, start_line - 1)) == "" then break end
		start_line = start_line - 1
	end

	local end_line = current_line
	while end_line < line_count do
		if vim.trim(get_line_text(0, end_line + 1)) == "" then break end
		end_line = end_line + 1
	end

	return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
end

return M
