vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

---@param content string
---@param hl string
---@return string
local function f(content, hl)
	if content == "" then return "" end
	return string.format("%%#%s#%s", hl, content)
end

local theme = require("src.highlights")
local set_hl = vim.api.nvim_set_hl

set_hl(0, "StFilename", { bg = theme.syn.fun, fg = theme.ui.bg, bold = true })
set_hl(0, "StPosition", { link = "CursorLineNr" })
set_hl(0, "StPositionBg", { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter })

set_hl(0, "StatusLine", { link = "WinSeparator" })
set_hl(0, "StatusLineNC", { link = "WinSeparator" })

---@param buf integer
---@return boolean
local function is_file_buffer(buf) return vim.api.nvim_get_option_value("buftype", { buf = buf }) == "" end

---@param buf integer
---@param value string
local function update_windows_statusline(buf, value)
	local wins = vim.fn.getbufinfo(buf)[1].windows
	for _, win in pairs(wins) do
		vim.api.nvim_set_option_value("statusline", value, { win = win })
	end
end

---@param buf integer
local function update_statusline(buf)
	local filename = vim.fn.getbufvar(buf, "st_filename")
	if not is_file_buffer(buf) or filename:match("Files:") then
		return update_windows_statusline(buf, filename .. "  %*")
	end

	local s = vim.tbl_filter(function(v) return v ~= "" end, {
		filename,
		vim.fn.getbufvar(buf, "st_diagnostics"),
		"%=",
		vim.fn.getbufvar(buf, "st_diff"),
		vim.fn.getbufvar(buf, "st_position"),
	})

	update_windows_statusline(buf, table.concat(s, "%*  "))
end

---@param name string
---@param value_fn function
---@return function
local function set_component_callback(name, value_fn)
	return function(ev)
		vim.api.nvim_buf_set_var(ev.buf, name, value_fn(ev.buf))
		update_statusline(ev.buf)
	end
end

---@param filename string
---@return string
local function format_filename(filename) return f(" " .. filename .. " %*", "StFilename") end

---@param buf integer
---@return string
local function update_filename(buf)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
	if filetype == "qf" then
		return format_filename("Quickfix List")
	elseif filetype == "DiffviewFiles" then
		return format_filename("Changed Files")
	elseif filetype == "DiffviewFileHistory" then
		return format_filename("Commit History")
	end

	local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
	if filename == "" then
		return format_filename("[No Name]")
	elseif filename == "Neotest Summary" then
		return format_filename("Test Summary")
	elseif vim.startswith(filename, "term:") then
		return format_filename(vim.split(filename, ":")[3])
	elseif vim.startswith(filename, "[dap-repl") then
		return format_filename("DAP REPL")
	elseif vim.startswith(filename, "oil:") then
		return format_filename(string.gsub(filename, "oil://", "Files: "))
	elseif vim.startswith(filename, "diffview:") then
		if filename == "diffview://null" then return format_filename("(no file)") end

		local gits = vim.split(filename, "/.git/", { plain = true })
		if #gits ~= 2 then return format_filename("(no file)") end

		local sha, file = gits[2]:match("^([^/]+)/(.+)")
		if sha ~= nil then filename = sha:sub(1, 8) .. ": " .. file end
		return format_filename(filename)
	end

	return format_filename(filename)
end
vim.api.nvim_create_autocmd(
	{ "BufWinEnter", "TermOpen" },
	{ callback = set_component_callback("st_filename", update_filename) }
)

---@param buf integer
---@return string
local function update_diagnostics(buf)
	if not is_file_buffer(buf) then return "" end

	local diagnostics = vim.diagnostic.get(buf)
	local count = { 0, 0, 0, 0 }
	for _, diagnostic in ipairs(diagnostics) do
		count[diagnostic.severity] = count[diagnostic.severity] + 1
	end

	local strings = {}
	local n = count[vim.diagnostic.severity.ERROR]
	if n > 0 then table.insert(strings, f("E:" .. n, "DiagnosticError")) end
	n = count[vim.diagnostic.severity.WARN]
	if n > 0 then table.insert(strings, f("W:" .. n, "DiagnosticWarn")) end
	n = count[vim.diagnostic.severity.INFO]
	if n > 0 then table.insert(strings, f("I:" .. n, "DiagnosticInfo")) end
	n = count[vim.diagnostic.severity.HINT]
	if n > 0 then table.insert(strings, f("H:" .. n, "DiagnosticHint")) end

	return table.concat(strings, " ")
end
vim.api.nvim_create_autocmd(
	{ "DiagnosticChanged" },
	{ callback = set_component_callback("st_diagnostics", update_diagnostics) }
)

-- Reference: https://github.com/nvim-lualine/lualine.nvim/blob/6a40b530539d2209f7dc0492f3681c8c126647ad/lua/lualine/components/diff/git_diff.lua#L59
---@param buf integer
---@return string
local function update_git_diff(buf)
	if not is_file_buffer(buf) then return "" end

	local output = vim.system({
		"git",
		"-C",
		vim.fn.expand("%:h"),
		"--no-pager",
		"diff",
		"--no-color",
		"--no-ext-diff",
		"-U0",
		"--",
		vim.fn.expand("%:t"),
	}, { text = true })
		:wait().stdout
	if not output or output == "" then return "" end

	local lines = vim.fn.split(output, "\n")

	local added, deleted, changed = 0, 0, 0
	for _, line in ipairs(lines) do
		if string.find(line, [[^@@ ]]) then
			local tokens = vim.fn.matchlist(line, [[^@@ -\v(\d+),?(\d*) \+(\d+),?(\d*)]])
			local line_stats = {
				mod_count = tokens[3] == nil and 0 or tokens[3] == "" and 1 or tonumber(tokens[3]),
				new_count = tokens[5] == nil and 0 or tokens[5] == "" and 1 or tonumber(tokens[5]),
			}

			if line_stats.mod_count == 0 and line_stats.new_count > 0 then
				added = added + line_stats.new_count
			elseif line_stats.mod_count > 0 and line_stats.new_count == 0 then
				deleted = deleted + line_stats.mod_count
			else
				local min = math.min(line_stats.mod_count, line_stats.new_count)
				changed = changed + min
				added = added + line_stats.new_count - min
				deleted = deleted + line_stats.mod_count - min
			end
		end
	end

	local strings = {}
	if added > 0 then table.insert(strings, f(" " .. added, "diffAdded")) end
	if changed > 0 then table.insert(strings, f(" " .. changed, "diffChanged")) end
	if deleted > 0 then table.insert(strings, f(" " .. deleted, "diffDeleted")) end

	return table.concat(strings, " ")
end
vim.api.nvim_create_autocmd(
	{ "BufEnter", "BufWritePost" },
	{ callback = set_component_callback("st_diff", update_git_diff) }
)

---@param buf integer
---@return string
local function update_position(buf)
	if not is_file_buffer(buf) then return "" end

	return "%#StPosition# %3l,%-5(%c%V%#StPositionBg#%)%#StPosition# %3p%% "
end
vim.api.nvim_create_autocmd({ "BufWinEnter" }, { callback = set_component_callback("st_position", update_position) })
