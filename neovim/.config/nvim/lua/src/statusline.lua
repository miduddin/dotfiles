---@param content string
---@param hl string
---@return string
local function f(content, hl)
	if content == "" then
		return ""
	end
	return string.format("%%#%s#%s", hl, content)
end

local colors = require("config.colors")
vim.api.nvim_set_hl(0, "StFilename", { bg = colors.blue, fg = colors.black, bold = true })
vim.api.nvim_set_hl(0, "StFilenameInv", { fg = colors.blue })
vim.api.nvim_set_hl(0, "StBranch", { fg = colors.magenta, bold = true })
vim.api.nvim_set_hl(0, "StFiletype", { fg = colors.fg })
vim.api.nvim_set_hl(0, "StPosition", { link = "CursorLineNr" })

local statusline = {
	"filename",
	"diagnostics",
	"%=",
	"diff",
	"branch",
	"filetype",
	"position",
}

local space = "%#StNormal#  "

local function update_statusline()
	local s = vim.tbl_filter(function(v)
		return v ~= ""
	end, statusline)

	vim.wo.statusline = table.concat(s, space)
end

---@return boolean
local function is_file_buffer()
	return vim.bo.buftype == ""
end

local function update_filename()
	local filename = vim.api.nvim_buf_get_name(0)
	if vim.bo.filetype == "qf" then
		filename = "Quickfix list"
	else
		filename = vim.fn.fnamemodify(filename, ":.")
		if filename == "" then
			filename = "[No Name]"
		end

		for i = 4, 1, -1 do
			if vim.bo.filetype ~= "oil" and filename:len() / vim.fn.winwidth(0) > 0.42 then
				filename = vim.fn.pathshorten(filename, i)
			else
				break
			end
		end
	end

	statusline[1] = f(" " .. filename .. " ", "StFilename") .. f("", "StFilenameInv")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "WinResized" }, { callback = update_filename })

local function update_diagnostics()
	if not is_file_buffer() then
		statusline[2] = ""
		update_statusline()
		return
	end

	local diagnostics = vim.diagnostic.get(0)
	local count = { 0, 0, 0, 0 }
	for _, diagnostic in ipairs(diagnostics) do
		count[diagnostic.severity] = count[diagnostic.severity] + 1
	end

	local strings = {}
	local n = count[vim.diagnostic.severity.ERROR]
	if n > 0 then
		table.insert(strings, f("E:" .. n, "DiagnosticError"))
	end
	n = count[vim.diagnostic.severity.WARN]
	if n > 0 then
		table.insert(strings, f("W:" .. n, "DiagnosticWarn"))
	end
	n = count[vim.diagnostic.severity.INFO]
	if n > 0 then
		table.insert(strings, f("I:" .. n, "DiagnosticInfo"))
	end
	n = count[vim.diagnostic.severity.HINT]
	if n > 0 then
		table.insert(strings, f("H:" .. n, "DiagnosticHint"))
	end

	statusline[2] = table.concat(strings, " ")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "DiagnosticChanged" }, { callback = update_diagnostics })

-- Reference: https://github.com/nvim-lualine/lualine.nvim/blob/6a40b530539d2209f7dc0492f3681c8c126647ad/lua/lualine/components/diff/git_diff.lua#L59
local function update_git_diff()
	if not is_file_buffer() then
		statusline[4] = ""
		update_statusline()
		return
	end

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
		statusline[4] = ""
		update_statusline()
		return
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
	if added > 0 then
		table.insert(strings, f(" " .. added, "diffAdded"))
	end
	if changed > 0 then
		table.insert(strings, f(" " .. changed, "diffChanged"))
	end
	if deleted > 0 then
		table.insert(strings, f(" " .. deleted, "diffDeleted"))
	end

	statusline[4] = table.concat(strings, " ")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, { callback = update_git_diff })

local function update_git_branch()
	if not is_file_buffer() then
		statusline[5] = ""
		update_statusline()
		return
	end

	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	if not branch or branch == "" then
		branch = ""
	else
		branch = " " .. branch:gsub("[%c%s]", "")
	end

	statusline[5] = f(branch, "StBranch")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = update_git_branch })

local function update_filetype()
	if not is_file_buffer() then
		statusline[6] = ""
		update_statusline()
		return
	end

	local filetype, icon, iconhl, ext = "", "", "", ""

	if vim.bo.buftype == "terminal" then
		icon, iconhl, ext = "", "Type", "terminal"
	else
		local filename = vim.fn.expand("%:t")
		if filename == "" or filename == "." then
			statusline[6] = ""
			update_statusline()
			return
		end

		ext = vim.bo.filetype
		icon, iconhl = require("nvim-web-devicons").get_icon(filename, nil, { default = true })
		if ext == "" then
			ext = "(unknown type)"
		end
	end

	filetype = f(icon .. " ", iconhl) .. f(ext, "StFiletype")

	statusline[6] = filetype
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "TermEnter" }, { callback = update_filetype })

local function update_position()
	if not is_file_buffer() then
		statusline[7] = ""
		update_statusline()
		return
	end

	statusline[7] = f("%3l:%-3c %3p%% ", "StPosition")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = update_position })
