vim.opt.showtabline = 2

local theme = require("src.highlights")
local set_hl = vim.api.nvim_set_hl

set_hl(0, "TabTabs", { bg = theme.identifier, fg = theme.bg, bold = true })
set_hl(0, "TabBufferActive", { bg = theme.func, fg = theme.bg, bold = true })
set_hl(0, "TabBufferInactive", { bg = theme.bg_float, fg = theme.comment })
set_hl(0, "TabGitBranch", { bg = theme.bg_float, fg = theme.keyword })
set_hl(0, "TabGitProject", { bg = theme.keyword, fg = theme.bg, bold = true })

---@param text string
---@param hl string
---@return string
local function f(text, hl) return string.format("%%#%s#%s", hl, text) end

local function update_tabline()
	local tabline = table.concat({
		vim.g.tab_buffers or "",
		"%=",
		vim.g.tab_tabs or "",
		vim.g.tab_git or "",
	})
	vim.api.nvim_set_option_value("tabline", tabline, { scope = "global" })
end

---@param name string
---@param value_fn function
---@return function
local function set_component_callback(name, value_fn)
	return function(ev)
		local value = value_fn(ev)
		vim.api.nvim_set_var(name, value)
		vim.api.nvim_set_var(name .. "_len", vim.api.nvim_eval_statusline(value, {}).width)
		update_tabline()
	end
end

---@param buf integer
---@return string
local function buffer_name(buf)
	local bufname = vim.api.nvim_buf_get_name(buf)
	bufname = vim.fn.fnamemodify(bufname, ":t")

	if bufname == "" then return "[No Name]" end
	return bufname
end

---@return string
local function update_buffers(ev)
	local space = vim.api.nvim_get_option_value("columns", { scope = "global" })
		- (vim.g.tab_tabs_len or 0)
		- (vim.g.tab_git_len or 0)

	local bufname_count = {}
	local buffers, len = "", 0
	local active_begin_at = 0
	local curbuf = vim.api.nvim_get_current_buf()

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if
			vim.api.nvim_get_option_value("buflisted", { buf = buf })
			and not (ev.event == "BufDelete" and ev.buf == buf)
		then
			local bufname = buffer_name(buf)
			local count = bufname_count[bufname] or 0
			bufname_count[bufname] = count + 1
			if count > 0 then bufname = bufname .. "(" .. count .. ")" end

			local hl = "TabBufferInactive"
			if curbuf == buf then
				hl = "TabBufferActive"
				active_begin_at = len + 1
			end

			local text = " " .. bufname .. " "
			local extra_len = (len + text:len() - active_begin_at + 1) - space
			if active_begin_at > 1 then extra_len = extra_len + 1 end

			if active_begin_at > 0 and extra_len > 0 then
				text = text:sub(1, text:len() - extra_len - 1) .. ">"
				buffers = buffers .. f(text, "TabBufferInactive")
				break
			else
				buffers = buffers .. f(text, hl)
			end
			len = len + text:len()
		end
	end

	return buffers .. "%*"
end
vim.api.nvim_create_autocmd(
	{ "BufAdd", "BufEnter", "BufDelete", "VimResized" },
	{ callback = set_component_callback("tab_buffers", update_buffers) }
)

---@return string
local function update_tabs()
	local n = vim.fn.tabpagenr("$")
	if n == 1 then return "" end

	local text = string.format(" Tab %d/%d ", vim.fn.tabpagenr(), n)
	return f(text, "TabTabs")
end
vim.api.nvim_create_autocmd({ "TabEnter", "TabClosed" }, { callback = set_component_callback("tab_tabs", update_tabs) })

---@return string
local function update_git()
	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	local cwd = vim.uv.cwd()
	if not branch or branch == "" or not cwd then return "" end

	branch = " 󰘬 " .. branch:gsub("[%c%s]", "") .. " "
	local project = " " .. vim.fn.fnamemodify(cwd, ":t") .. " "
	return f(branch, "TabGitBranch") .. f(project, "TabGitProject")
end
vim.api.nvim_create_autocmd(
	{ "VimEnter", "TabEnter", "FocusGained" },
	{ callback = set_component_callback("tab_git", update_git) }
)
