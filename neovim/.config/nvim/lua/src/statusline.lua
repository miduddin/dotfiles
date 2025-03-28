vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

---@param content string
---@param hl string
---@return string
local function f(content, hl)
	if content == "" then return "" end
	return string.format("%%#%s#%s", hl, content)
end

local theme = require("src.highlights")
local set = vim.api.nvim_set_hl

set(0, "StFilename", { bg = theme.syn.fun, fg = theme.ui.bg, bold = true })
set(0, "StBranch", { fg = theme.syn.keyword, bold = true })
set(0, "StPosition", { link = "CursorLineNr" })
set(0, "StPositionBg", { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter })

set(0, "StatusLine", { link = "WinSeparator" })
set(0, "StatusLineNC", { link = "WinSeparator" })

local space = "%*  "

---@return boolean
local function is_file_buffer() return vim.bo.buftype == "" end

---@param bufnr integer
---@param statusline string
local function update_windows_statusline(bufnr, statusline)
	local winids = vim.fn.getbufinfo(bufnr)[1].windows
	for _, winid in pairs(winids) do
		vim.wo[winid].statusline = statusline
	end
end

local function update_statusline()
	local filename = vim.b.st_filename or ""

	if not is_file_buffer() or filename:match("Files:") then
		return update_windows_statusline(vim.fn.bufnr(), filename .. "  %*")
	end

	local diagnostics = vim.b.st_diagnostics or ""
	local diff = vim.b.st_diff or ""
	local branch = vim.b.st_branch or ""
	local position = vim.b.st_position or ""

	local s = vim.tbl_filter(function(v) return v ~= "" end, { filename, diagnostics, "%=", diff, branch, position })

	update_windows_statusline(vim.fn.bufnr(), table.concat(s, space))
end

---@param filename string
---@return string
local function format_filename(filename) return f(" " .. filename .. " %*", "StFilename") end

local function update_filename()
	local filetype = vim.bo.filetype
	if filetype == "qf" then
		vim.b.st_filename = format_filename("Quickfix List")
		return update_statusline()
	elseif filetype == "DiffviewFiles" then
		vim.b.st_filename = format_filename("Changed Files")
		return update_statusline()
	elseif filetype == "DiffviewFileHistory" then
		vim.b.st_filename = format_filename("Commit History")
		return update_statusline()
	end

	local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
	if filename == "" then
		vim.b.st_filename = format_filename("[No Name]")
		return update_statusline()
	elseif filename == "Neotest Summary" then
		vim.b.st_filename = format_filename("Test Summary")
		return update_statusline()
	elseif vim.startswith(filename, "term:") then
		vim.b.st_filename = format_filename(vim.split(filename, ":")[3])
		return update_statusline()
	elseif vim.startswith(filename, "[dap-repl") then
		vim.b.st_filename = format_filename("DAP REPL")
		return update_statusline()
	elseif vim.startswith(filename, "oil:") then
		vim.b.st_filename = format_filename(string.gsub(filename, "oil://", "Files: "))
		return update_statusline()
	elseif vim.startswith(filename, "diffview:") then
		if filename == "diffview://null" then
			vim.b.st_filename = format_filename("(no file)")
			return update_statusline()
		end
		local gits = vim.split(filename, "/.git/", { plain = true })
		if #gits ~= 2 then
			vim.b.st_filename = format_filename("(no file)")
			return update_statusline()
		end
		local sha, file = gits[2]:match("^([^/]+)/(.+)")
		if sha ~= nil then filename = sha:sub(1, 8) .. ": " .. file end
		vim.b.st_filename = format_filename(filename)
		return update_statusline()
	end

	vim.b.st_filename = format_filename(filename)
	return update_statusline()
end
vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, { callback = update_filename })

local function update_diagnostics()
	if not is_file_buffer() then return end

	local diagnostics = vim.diagnostic.get(0)
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

	vim.b.st_diagnostics = table.concat(strings, " ")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, { callback = update_diagnostics })

-- Reference: https://github.com/nvim-lualine/lualine.nvim/blob/6a40b530539d2209f7dc0492f3681c8c126647ad/lua/lualine/components/diff/git_diff.lua#L59
local function update_git_diff()
	if not is_file_buffer() then return end

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
	if not output or output == "" then
		vim.b.st_diff = ""
		return update_statusline()
	end

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

	vim.b.st_diff = table.concat(strings, " ")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, { callback = update_git_diff })

local function update_git_branch()
	if not is_file_buffer() then return end

	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	if not branch or branch == "" then
		branch = ""
	else
		branch = "󰘬 " .. branch:gsub("[%c%s]", "")
	end

	vim.b.st_branch = f(branch, "StBranch")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = update_git_branch })

local function update_position()
	if not is_file_buffer() then return end

	vim.b.st_position = "%#StPosition# %3l,%-7(%c%V%#StPositionBg#%)%#StPosition# %3p%% "
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufWinEnter" }, { callback = update_position })
