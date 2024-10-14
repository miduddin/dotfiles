local M = {}

---@param obj vim.SystemObj
---@param bufname string
function M.write_cmd_output_to_split(obj, bufname)
	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, bufname)
	vim.api.nvim_win_set_buf(win, buf)
	vim.keymap.set("n", "q", "<Cmd>bd<CR>", { desc = "Close buffer", buffer = buf })

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

return M
