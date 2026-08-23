local function add_row_below()
	local line_current = vim.pos.cursor().row
	local text_next = require("utils").get_line(line_current)
	local text_current = text_next:gsub("%);", "),", 1)
	local row_id = string.match(text_current, "%d+")
	text_next = text_next:gsub(row_id, row_id + 1)
	vim.api.nvim_buf_set_lines(0, line_current, line_current + 1, true, { text_current, text_next })
	vim.fn.feedkeys("j")
end
Map("<Leader>.r", require("utils").dot_repeat(add_row_below), "n", { expr = true })

---@param line integer?
---@param next_down boolean?
local function align_columns(line, next_down)
	if type(line) ~= "number" then line = vim.pos.cursor().row end

	local utils = require("utils")
	local text = utils.get_line(line)
	if vim.startswith(vim.trim(text), "insert into") then
		align_columns(line - 1, false)
		align_columns(line + 1, true)
		return
	end

	if not vim.startswith(vim.trim(text), "(") then return end

	local indent = vim.fn.indent(line + 1)
	local rows = { text }

	local line_start = line
	while true do
		if vim.fn.indent(line_start) ~= indent then break end
		line_start = line_start - 1
		text = utils.get_line(line_start)
		table.insert(rows, 1, text)
	end

	local line_end = line
	while true do
		if vim.fn.indent(line_end + 2) ~= indent then break end
		line_end = line_end + 1
		text = utils.get_line(line_end)
		table.insert(rows, text)
	end

	---@param s string
	---@param start integer
	---@return integer?, integer?
	local next_segment = function(s, start)
		local comma, quote, space = string.byte(",' ", 1, 3)
		local next_comma, next_col, look_for = nil, nil, comma
		for i = start, #s do
			local c = s:byte(i)
			if look_for == comma then
				if c == comma then
					next_comma, look_for = i, 0
				elseif c == quote then
					look_for = quote
				end
			elseif look_for == quote then
				if c == quote then look_for = comma end
			elseif look_for == 0 then
				if c ~= space then
					next_col = i
					break
				end
			end
		end
		return next_comma, next_col
	end

	local start = 1
	while true do
		local max_comma = 0
		for i = 1, #rows do
			local next_comma, next_col = next_segment(rows[i], start)
			if not next_comma or not next_col then
				max_comma = 0
				break
			end
			max_comma = math.max(max_comma, next_comma)
		end
		if max_comma == 0 then break end

		for i = 1, #rows do
			local next_comma, next_col = next_segment(rows[i], start)
			rows[i] = rows[i]:sub(1, next_comma)
				.. string.rep(" ", 1 + max_comma - next_comma)
				.. rows[i]:sub(assert(next_col), -1)
		end

		start = max_comma + 2
	end

	vim.api.nvim_buf_set_lines(0, line_start, line_end + 1, true, rows)

	if next_down == nil then
		align_columns(line_start - 2, false)
		align_columns(line_end + 2, true)
	elseif next_down then
		align_columns(line_end + 2, true)
	else
		align_columns(line_start - 2, false)
	end
end
Map("<Leader>.c", require("utils").dot_repeat(align_columns), "n", { expr = true })
