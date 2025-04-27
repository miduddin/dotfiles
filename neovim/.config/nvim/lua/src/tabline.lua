vim.opt.showtabline = 2

local theme = require("src.highlights")
local set_hl = vim.api.nvim_set_hl

set_hl(0, "TabTabs", { bg = theme.syn.identifier, fg = theme.ui.bg, bold = true })
set_hl(0, "TabBufferActive", { bg = theme.syn.fun, fg = theme.ui.bg, bold = true })
set_hl(0, "TabBufferInactive", { bg = theme.ui.bg_float, fg = theme.syn.comment })
set_hl(0, "TabGitBranch", { bg = theme.ui.bg_float, fg = theme.syn.keyword })
set_hl(0, "TabGitProject", { bg = theme.syn.keyword, fg = theme.ui.bg, bold = true })

---@param text string
---@param hl string
---@return string
local function f(text, hl) return string.format("%%#%s#%s", hl, text) end

---@class Component
---@field val string
---@field len integer
---@field last_hl string?
local Component = {}
Component.__index = Component

---@return Component
function Component.new()
	local self = setmetatable({}, Component)
	self:clear()
	return self
end

function Component:clear()
	self.val = ""
	self.len = 0
	self.last_hl = nil
end

---@param text string
---@param hl string
function Component:set(text, hl)
	if text == "" then self:clear() end
	self.val = f(text, hl)
	self.len = text:len()
	self.last_hl = hl
end

---@param text string
---@param hl string
function Component:append(text, hl)
	if text == "" then return end

	self.len = self.len + text:len()
	if hl == self.last_hl then
		self.val = self.val .. text
	else
		self.val = self.val .. f(text, hl)
		self.last_hl = hl
	end
end

---@class Tabline
---@field tabs Component
---@field buffers Component
---@field git Component
local Tabline = {
	buffers = Component.new(),
	tabs = Component.new(),
	git = Component.new(),
}

function Tabline:update()
	local s = vim.tbl_filter(function(v) return v ~= "" end, {
		self.buffers.val,
		"%=",
		self.tabs.val,
		self.git.val,
	})

	vim.o.tabline = table.concat(s, "%*")
end

---@return nil
function Tabline:update_tabs()
	self.tabs:clear()

	local n = vim.fn.tabpagenr("$")
	if n == 1 then return end

	local text = string.format(" Tab %d/%d ", vim.fn.tabpagenr(), n)
	self.tabs:set(text, "TabTabs")
end
vim.api.nvim_create_autocmd({ "TabEnter", "TabClosed" }, {
	callback = function()
		Tabline:update_tabs()
		Tabline:update()
	end,
})

---@param buf_id integer
---@return string
local function buffer_name(buf_id)
	local bufname = vim.api.nvim_buf_get_name(buf_id)
	bufname = vim.fn.fnamemodify(bufname, ":t")

	if bufname == "" then return "[No Name]" end
	return bufname
end

function Tabline:update_buffers(ev)
	self.buffers:clear()

	local bufname_count = {}
	local space = vim.o.columns - self.tabs.len - self.git.len
	local active_begin_at = 0

	for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf_id].buflisted and not (ev.event == "BufDelete" and ev.buf == buf_id) then
			local bufname = buffer_name(buf_id)
			local count = bufname_count[bufname] or 0
			bufname_count[bufname] = count + 1
			if count > 0 then bufname = bufname .. "(" .. count .. ")" end

			local hl = "TabBufferInactive"
			if vim.api.nvim_get_current_buf() == buf_id then
				hl = "TabBufferActive"
				active_begin_at = self.buffers.len + 1
			end

			local text = " " .. bufname .. " "
			local new_len = self.buffers.len + text:len()
			local extra_len = (new_len - active_begin_at + 1) - space
			if active_begin_at > 1 then extra_len = extra_len + 1 end

			if active_begin_at > 0 and extra_len > 0 then
				text = text:sub(1, text:len() - extra_len - 1) .. ">"
				self.buffers:append(text, "TabBufferInactive")
				return
			else
				self.buffers:append(text, hl)
			end
		end
	end
end
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "BufDelete", "VimResized" }, {
	callback = function(ev)
		Tabline:update_buffers(ev)
		Tabline:update()
	end,
})

function Tabline:update_git()
	self.git:clear()

	local branch = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait().stdout
	if not branch or branch == "" then return end

	branch = " 󰘬 " .. branch:gsub("[%c%s]", "") .. " "
	self.git:append(branch, "TabGitBranch")
	self.git.len = self.git.len - 3

	local project = " " .. vim.fn.fnamemodify(vim.uv.cwd(), ":t") .. " "
	self.git:append(project, "TabGitProject")
end
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		Tabline:update_git()
		Tabline:update()
	end,
})
