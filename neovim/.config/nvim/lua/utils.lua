local M = {}

---@param obj vim.SystemObj
---@param bufname string
function M.write_cmd_output_to_split(obj, bufname)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, bufname)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	Map("q", "<Cmd>bd<CR>", "n", { desc = "Close buffer", buf = buf })

	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_set_option_value("winfixbuf", true, { win = win })

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

---@param linenr integer 0-based line number.
function M.get_line(linenr) return vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, false)[1] end

---@return string[]
function M.get_current_paragraph()
	local current_linenr = vim.pos.cursor().row
	assert(vim.trim(M.get_line(current_linenr)) ~= "", "Current line is empty!")

	local line_count = vim.api.nvim_buf_line_count(0)

	local start_linenr = current_linenr
	while start_linenr > 1 do
		if vim.trim(M.get_line(start_linenr - 1)) == "" then break end
		start_linenr = start_linenr - 1
	end

	local end_linenr = current_linenr
	while end_linenr < line_count do
		if vim.trim(M.get_line(end_linenr + 1)) == "" then break end
		end_linenr = end_linenr + 1
	end

	return vim.api.nvim_buf_get_lines(0, start_linenr, end_linenr + 1, false)
end

function M.dot_repeat(callback)
	return function()
		vim.go.operatorfunc = callback
		return "g@l"
	end
end

return M
