local function add_row_below()
	local line_current = vim.api.nvim_win_get_cursor(0)[1]
	local text_next = require("utils").get_line_text(line_current)
	local text_current = text_next:sub(1, -2) .. ","
	local row_id = string.match(text_current, "%d+")
	text_next = text_next:gsub(row_id, row_id + 1)
	vim.api.nvim_buf_set_lines(0, line_current - 1, line_current, true, { text_current, text_next })
	vim.fn.feedkeys("j")
end
Map("<Leader>.r", require("utils").dot_repeat(add_row_below), "n", { expr = true })

---@param line integer?
---@param next_down boolean?
local function columnize_rows(line, next_down)
	if type(line) ~= "number" then line = vim.api.nvim_win_get_cursor(0)[1] end

	---@param text string
	local normalize_spacing = function(text) return text:gsub(", +", ", "):gsub(" +$", "") end

	local utils = require("utils")
	local text = normalize_spacing(utils.get_line_text(line))
	if vim.startswith(vim.trim(text), "insert into") then
		columnize_rows(line - 1, false)
		columnize_rows(line + 1, true)
		return
	end

	if not vim.startswith(vim.trim(text), "(") then return end

	local indent = vim.fn.indent(line)
	local rows = { text }

	local line_start = line
	while true do
		if vim.fn.indent(line_start - 1) ~= indent then break end
		line_start = line_start - 1
		text = normalize_spacing(utils.get_line_text(line_start))
		table.insert(rows, 1, text)
	end

	local line_end = line
	while true do
		if vim.fn.indent(line_end + 1) ~= indent then break end
		line_end = line_end + 1
		text = normalize_spacing(utils.get_line_text(line_end))
		table.insert(rows, text)
	end

	---@param s string
	---@param start integer
	---@return integer?
	local next_comma = function(s, start)
		local comma, quote = string.byte(",'", 1, 2)
		local in_string = false
		for i = start, #s do
			local c = s:byte(i)
			if c == comma and not in_string then return i end
			if c == quote then in_string = not in_string end
		end
		return nil
	end

	local comma_init = 1
	while true do
		local max_comma_index = 0
		for _, line2 in ipairs(rows) do
			local index = next_comma(line2, comma_init)
			if index == nil or index == #line2 then
				max_comma_index = 0
				break
			end
			max_comma_index = math.max(max_comma_index, index)
		end
		if max_comma_index == 0 then break end

		for i, line2 in ipairs(rows) do
			local comma_index = next_comma(line2, comma_init)
			if comma_index ~= max_comma_index then
				rows[i] = line2:sub(1, comma_index)
					.. string.rep(" ", max_comma_index - comma_index)
					.. line2:sub(comma_index + 1, -1)
			end
		end

		comma_init = max_comma_index + 1
	end

	vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, rows)

	if next_down == nil then
		columnize_rows(line_start - 2, false)
		columnize_rows(line_end + 2, true)
	elseif next_down then
		columnize_rows(line_end + 2, true)
	else
		columnize_rows(line_start - 2, false)
	end
end
Map("<Leader>.c", require("utils").dot_repeat(columnize_rows), "n", { expr = true })
