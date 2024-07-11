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
vim.api.nvim_set_hl(0, "StNormal", { fg = colors.fg })
vim.api.nvim_set_hl(0, "StBranch", { fg = colors.magenta, bold = true })
vim.api.nvim_set_hl(0, "StFiletype", { bg = colors.bg_p1, fg = colors.fg })
vim.api.nvim_set_hl(0, "StFiletypeInv", { fg = colors.bg_p1 })
vim.api.nvim_set_hl(0, "StPosition", { fg = colors.orange })

---@type table<string, string>
local statusline = {
	"filename",
	"diagnostics",
	"%=",
	"diff",
	"branch",
	"filetype",
	f("%3l:%-3c %P", "StPosition"),
	"%#StFilename# ",
}

local space = "%#StNormal#  "

local function update_statusline()
	local s = vim.tbl_filter(function(v)
		return v ~= ""
	end, statusline)

	vim.go.statusline = table.concat(s, space)
end

local function update_filename()
	local filename = vim.api.nvim_buf_get_name(0)
	filename = vim.fn.fnamemodify(filename, ":.")
	if filename == "" then
		filename = "[No Name]"
	end
	if filename:len() / vim.o.columns > 0.35 then
		filename = vim.fn.pathshorten(filename)
	end

	statusline[1] = f(" " .. filename .. " ", "StFilename") .. f("", "StFilenameInv")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "BufEnter", "WinResized" }, { callback = update_filename })

local function update_diagnostics()
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
vim.api.nvim_create_autocmd({ "VimEnter", "DiagnosticChanged" }, { callback = update_diagnostics })

-- Reference: https://github.com/nvim-lualine/lualine.nvim/blob/6a40b530539d2209f7dc0492f3681c8c126647ad/lua/lualine/components/diff/git_diff.lua#L59
local function update_git_diff()
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
	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	if not branch or branch == "" then
		branch = ""
	else
		branch = " " .. branch:gsub("[%c%s]", "")
	end

	statusline[5] = f(branch, "StBranch")
	update_statusline()
end
vim.api.nvim_create_autocmd({ "TermLeave", "FocusGained", "VimEnter" }, { callback = update_git_branch })

local function update_filetype()
	local filename = vim.fn.expand("%:t")
	local filetype = ""
	if filename == "" or filename == "." then
		statusline[6] = ""
		update_statusline()
		return
	end

	local ext = vim.bo.filetype
	local icon, iconhl = require("nvim-web-devicons").get_icon(filename, nil, { default = true })
	if ext == "" then
		ext = "(unknown type)"
	end

	local iconhlmap = vim.api.nvim_get_hl(0, { name = iconhl })
	vim.api.nvim_set_hl(0, "StFiletypeIcon", { bg = colors.bg_p1, fg = iconhlmap.fg })

	filetype = f("", "StFiletypeInv")
		.. f(" " .. icon .. " ", "StFiletypeIcon")
		.. f(ext .. " ", "StFiletype")
		.. f("", "StFiletypeInv")

	statusline[6] = filetype
	update_statusline()
end
vim.api.nvim_create_autocmd("BufEnter", { callback = update_filetype })
