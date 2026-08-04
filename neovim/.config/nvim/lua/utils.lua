local M = {}

---@param bufname string
---@param cmd string[]
---@param stdin string[]?
---@return integer window id
function M.write_cmd_output_to_split(bufname, cmd, stdin)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "Running: " .. table.concat(cmd, " "), "" })

	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_set_option_value("winfixbuf", true, { win = win })

	---@param data string?
	local on_stdout = function(_, data)
		if data then
			vim.schedule(function()
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(data:gsub("\n+$", ""), "\n"))
				vim._with({ win = win }, function() vim.cmd("norm G") end)
			end)
		end
	end
	---@param out vim.SystemCompleted
	local on_exit = function(out)
		vim.schedule(function()
			Map("q", "<Cmd>bw<CR>", "n", { buf = buf })
			local text = string.format("[Exit code: %d, signal: %d]", out.code, out.signal)
			vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", text })
			vim._with({ win = win }, function() vim.cmd("norm G") end)
		end)
	end
	local obj = vim.system(cmd, { text = true, stdin = stdin, stdout = on_stdout, stderr = on_stdout }, on_exit)
	vim.api.nvim_buf_set_name(buf, obj.pid .. ":" .. bufname)

	Map("<C-c>", function()
		if obj:is_closing() then
			obj:kill("sigkill")
		else
			obj:kill("sigterm")
		end
	end, "n", { buf = buf })

	return win
end

---@param linenr integer 0-based line number.
function M.get_line(linenr) return vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, false)[1] end

---@return string[]
function M.get_current_paragraph()
	local current_linenr = vim.pos.cursor().row
	assert(vim.trim(M.get_line(current_linenr)) ~= "", "Current line is empty!")

	local line_count = vim.api.nvim_buf_line_count(0)

	local start_linenr = current_linenr
	while start_linenr > 0 do
		if vim.trim(M.get_line(start_linenr - 1)) == "" then break end
		start_linenr = start_linenr - 1
	end

	local end_linenr = current_linenr
	while end_linenr < line_count - 1 do
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
