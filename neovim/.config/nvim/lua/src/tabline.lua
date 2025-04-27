vim.opt.showtabline = 2

---@param content string
---@param hl string
---@return string
local function f(content, hl)
	if content == "" then return "" end
	return string.format("%%#%s#%s", hl, content)
end

local theme = require("src.highlights")
local set_hl = vim.api.nvim_set_hl

set_hl(0, "TabTabs", { bg = theme.syn.identifier, fg = theme.ui.bg, bold = true })
set_hl(0, "TabBufferActive", { bg = theme.syn.fun, fg = theme.ui.bg, bold = true })
set_hl(0, "TabBufferInactive", { bg = theme.ui.bg_float, fg = theme.syn.comment })
set_hl(0, "TabGitBranch", { bg = theme.ui.bg_float, fg = theme.syn.keyword })
set_hl(0, "TabGitProject", { bg = theme.syn.keyword, fg = theme.ui.bg, bold = true })

local function update_tabline()
	local tabs = vim.g.tab_tabs or ""
	local buffers = vim.g.tab_buffers or ""
	local git = vim.g.tab_git or ""

	local s = vim.tbl_filter(function(v) return v ~= "" end, { tabs, buffers, "%=", git })

	vim.o.tabline = table.concat(s, "%*")
end

---@param name string
---@param value_fn function
---@return function
local function set_component_callback(name, value_fn)
	return function(ev)
		vim.g["tab_" .. name] = value_fn(ev)
		update_tabline()
	end
end

---@return string
local function update_tabs()
	local n = vim.fn.tabpagenr("$")
	if n == 1 then return "" end

	local cur = vim.fn.tabpagenr()
	return f(" Tab " .. cur .. "/" .. n .. " ", "TabTabs")
end
vim.api.nvim_create_autocmd({ "TabEnter", "TabClosed" }, { callback = set_component_callback("tabs", update_tabs) })

---@param buf_id integer
---@return string
local function buffer_name(buf_id)
	local bufname = vim.api.nvim_buf_get_name(buf_id)
	bufname = vim.fn.fnamemodify(bufname, ":t")

	if bufname == "" then return "[No Name]" end
	return bufname
end

---@return string
local function update_buffers(ev)
	local buffers = ""
	local bufname_count = {}
	for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf_id].buflisted and not (ev.event == "BufDelete" and ev.buf == buf_id) then
			local bufname = buffer_name(buf_id)
			local count = bufname_count[bufname] or 0
			if count > 0 then bufname = bufname .. "(" .. count .. ")" end
			bufname_count[bufname] = count + 1

			local hl = vim.api.nvim_get_current_buf() == buf_id and "TabBufferActive" or "TabBufferInactive"

			buffers = buffers .. f(" " .. bufname .. " ", hl)
		end
	end
	return buffers
end
vim.api.nvim_create_autocmd(
	{ "BufEnter", "BufDelete" },
	{ callback = set_component_callback("buffers", update_buffers) }
)

---@return string
local function update_git()
	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	if not branch or branch == "" then return "" end

	branch = " 󰘬 " .. branch:gsub("[%c%s]", "") .. " "
	local project = " " .. vim.fn.fnamemodify(vim.uv.cwd(), ":t") .. " "

	return f(branch, "TabGitBranch") .. f(project, "TabGitProject")
end
vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = set_component_callback("git", update_git) })
