local function close_current_buffer()
	local ok, _ = pcall(function() vim.cmd("b# | bw#") end)
	if not ok then vim.cmd("bw") end
end

local function close_other_buffers()
	local curbuf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= curbuf and vim.fn.buflisted(buf) then vim.cmd("bw " .. buf) end
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

-- reorder arguments just so it looks better when sorted.
local map = function(rhs, lhs, mode, opts) vim.keymap.set(mode, lhs, rhs, opts) end

map("*``", "*", "n", { desc = "Search current word without going next" })
map("5j", "<C-J>", { "n", "v" }, { desc = "5 line down" })
map("5k", "<C-K>", { "n", "v" }, { desc = "5 line up " })
map("<Cmd>%bw<CR>", "<Leader>ba", "n", { desc = "Close all buffers" })
map("<Cmd>bn<CR>", "<S-L>", "n", { desc = "Next buffer" })
map("<Cmd>bp<CR>", "<S-H>", "n", { desc = "Prev buffer" })
map("<Cmd>noh<CR><Esc>", "<Esc>", { "n", "t" }, { desc = "Esc + clear search highlight" })
map("<Cmd>set wrap!<CR>", "<Leader>w", { "n", "v" }, { desc = "Toggle word wrap" })
map("<Cmd>tabclose<CR>", "<Leader><tab>d", "n", { desc = "Close tab" })
map("<Cmd>tabn<CR>", "<Leader><Tab>n", "n", { desc = "Next tab" })
map("<Cmd>tabp<CR>", "<Leader><Tab>p", "n", { desc = "Previous tab" })
map("<Cmd>w<CR>", "<C-S>", "n", { desc = "Save file" })
map("gc", "<C-_>", "v", { desc = "Toggle comment", remap = true })
map("gcc", "<C-_>", "n", { desc = "Toggle comment", remap = true })
map("ggVG", "<C-A>", "n", { desc = "Select all" })
map('"+P', "<Leader>P", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+p', "<Leader>p", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+y', "<Leader>y", { "n", "v" }, { desc = "Yank to clipboard" })
map(close_current_buffer, "<Leader>bd", "n", { desc = "Close current buffer" })
map(close_other_buffers, "<Leader>bo", "n", { desc = "Close other buffers" })
map(fold_children, "zC", "n", { desc = "Fold all children" })
map(function() toggle_diffmode() end, "<Leader>gw", "n", { desc = "Diff current window" })
map(function() toggle_diffmode(1) end, "<Leader>gW", "n", { desc = "Diff visible windows" })
map(function() toggle_diffopt("icase") end, "<Leader>C", "n", { desc = "Toggle case-sensitive diff" })
map(function() toggle_diffopt("iwhiteall") end, "<Leader>W", "n", { desc = "Toggle whitespace diff" })
map(toggle_quickfix, "<Leader>q", "n", { desc = "Toggle quickfix list" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		map(function() vim.lsp.buf.hover({ max_width = 82 }) end, "K", "n", { desc = "LSP Hover", buffer = ev.buf })
		map(toggle_diag, "<Leader>cD", "n", { desc = "Toggle diagnostics", buffer = ev.buf })
		map(toggle_diag_virt_lines, "<Leader>cd", "n", { desc = "Toggle diagnostics virtual lines", buffer = ev.buf })
		map(toggle_inlay_hint, "grh", "n", { desc = "Toggle inlay hint", buffer = ev.buf })
		map(vim.diagnostic.open_float, "<Leader>ce", "n", { desc = "Diagnostics (floating)", buffer = ev.buf })
		map(vim.diagnostic.setqflist, "<Leader>x", "n", { desc = "Diagnostics (quickfix list)", buffer = ev.buf })
		map(vim.lsp.buf.definition, "grd", { "n" }, { desc = "LSP definition", buffer = ev.buf })
		map(vim.lsp.buf.type_definition, "grD", { "n" }, { desc = "LSP type definition", buffer = ev.buf })
	end,
})
