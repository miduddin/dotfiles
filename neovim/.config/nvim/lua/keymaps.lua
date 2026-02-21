local function close_current_buffer()
	local ok, _ = pcall(function() vim.cmd("bn | bd#") end)
	if not ok then vim.cmd("bd") end
end

local function close_inactive_buffers()
	local visible_bufs = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		table.insert(visible_bufs, vim.api.nvim_win_get_buf(win))
	end

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.buflisted(buf) == 1 and not vim.list_contains(visible_bufs, buf) then vim.cmd("bd " .. buf) end
	end
end

local function fold_children()
	local topline = vim.fn.winsaveview().topline
	vim.cmd("norm zc")
	vim.api.nvim_cmd({ cmd = "foldc", bang = true, range = { vim.fn.line(".") } }, {})
	vim.cmd("norm zvzc")
	vim.fn.winrestview({ topline = topline })
end

local function toggle_quickfix()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end

---@param opt string
local function toggle_diffopt(opt)
	if vim.o.diffopt:find(opt) then
		vim.opt.diffopt:remove(opt)
	else
		vim.opt.diffopt:append(opt)
	end
end

local function toggle_diffmode(all)
	local prefix = ""
	if all then prefix = "windo " end
	if vim.api.nvim_get_option_value("diff", { scope = "local" }) then
		vim.cmd(prefix .. "diffo")
	else
		vim.cmd(prefix .. "difft")
	end
end

local function toggle_diag()
	local opts = { bufnr = 0 }
	local current_state = vim.diagnostic.is_enabled(opts)
	vim.diagnostic.enable(not current_state, opts)
end

local function toggle_diag_virt_lines()
	local current_state = vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_text = not not current_state, virtual_lines = not current_state })
end

local function toggle_inlay_hint()
	local opts = { bufnr = 0 }
	local current_state = vim.lsp.inlay_hint.is_enabled(opts)
	vim.lsp.inlay_hint.enable(not current_state, opts)
end

---Reorder arguments just so it looks better when sorted.
---
---@param lhs   string
---@param rhs   string|function
---@param mode  string|string[]
---@param opts? vim.keymap.set.Opts
function Map(lhs, rhs, mode, opts) vim.keymap.set(mode, lhs, rhs, opts) end

Map("*", "*``", "n", { desc = "Search current word without going next" })
Map("<", "<gv", "v", { desc = "Indent without clearing selection" })
Map("<C-/>", "gc", "v", { desc = "Toggle comment", remap = true })
Map("<C-/>", "gcc", "n", { desc = "Toggle comment", remap = true })
Map("<C-_>", "gc", "v", { desc = "Toggle comment", remap = true })
Map("<C-_>", "gcc", "n", { desc = "Toggle comment", remap = true })
Map("<C-J>", "5j", { "n", "v" }, { desc = "5 line down" })
Map("<C-K>", "5k", { "n", "v" }, { desc = "5 line up " })
Map("<C-S>", "<Cmd>w<CR>", "n", { desc = "Save file" })
Map("<Esc>", "<Cmd>noh<CR><Esc>", { "n", "t" }, { desc = "Esc + clear search highlight" })
Map("<Leader>ba", "<Cmd>%bd<CR>", "n", { desc = "Close all buffers" })
Map("<Leader>bd", close_current_buffer, "n", { desc = "Close current buffer" })
Map("<Leader>bo", close_inactive_buffers, "n", { desc = "Close inactive buffers" })
Map("<Leader>gd", function() toggle_diffmode() end, "n", { desc = "Diff current window" })
Map("<Leader>gD", function() toggle_diffmode(1) end, "n", { desc = "Diff visible windows" })
Map("<Leader>goc", function() toggle_diffopt("icase") end, "n", { desc = "Toggle case-sensitive diff" })
Map("<Leader>gow", function() toggle_diffopt("iwhiteall") end, "n", { desc = "Toggle whitespace diff" })
Map("<Leader>P", '"+P', { "n", "v" }, { desc = "Paste from clipboard" })
Map("<Leader>p", '"+p', { "n", "v" }, { desc = "Paste from clipboard" })
Map("<Leader>q", toggle_quickfix, "n", { desc = "Toggle quickfix list" })
Map("<Leader>w", "<Cmd>set wrap!<CR>", { "n", "v" }, { desc = "Toggle word wrap" })
Map("<Leader>y", '"+y', { "n", "v" }, { desc = "Yank to clipboard" })
Map("<S-H>", "<Cmd>bp<CR>", "n", { desc = "Prev buffer" })
Map("<S-L>", "<Cmd>bn<CR>", "n", { desc = "Next buffer" })
Map(">", ">gv", "v", { desc = "Indent without clearing selection" })
Map("zC", fold_children, "n", { desc = "Fold all children" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		Map("<Leader>X", toggle_diag, "n", { desc = "Diag: toggle", buffer = ev.buf })
		Map("<Leader>xf", vim.diagnostic.open_float, "n", { desc = "Diag: open in floating window", buffer = ev.buf })
		Map("<Leader>xq", vim.diagnostic.setqflist, "n", { desc = "Diag: open in quickfix", buffer = ev.buf })
		Map("<Leader>xv", toggle_diag_virt_lines, "n", { desc = "Diag: toggle virtual lines", buffer = ev.buf })
		Map("grd", vim.lsp.buf.definition, "n", { desc = "LSP definition", buffer = ev.buf })
		Map("grh", toggle_inlay_hint, "n", { desc = "Toggle inlay hint", buffer = ev.buf })
		Map(
			"grr",
			function() vim.lsp.buf.references({ includeDeclaration = false }) end,
			"n",
			{ desc = "LSP references", buffer = ev.buf }
		)
		Map(
			"K",
			function() vim.lsp.buf.hover({ max_width = 82, max_height = 20 }) end,
			"n",
			{ desc = "LSP Hover", buffer = ev.buf }
		)
	end,
})
