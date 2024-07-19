-- reorder arguments just so it looks better when sorted.
local map = function(rhs, lhs, mode, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
end

map("*``", "*", "n", { desc = "Search current word without going next" })
map("<C-w>h", "<C-h>", "n", { desc = "Go to left window" })
map("<C-w>j", "<C-j>", "n", { desc = "Go to below window" })
map("<C-w>k", "<C-k>", "n", { desc = "Go to above window" })
map("<C-w>l", "<C-l>", "n", { desc = "Go to right window" })
map("<Cmd>Lazy<CR>", "<leader>l", "n", { desc = "Lazy" })
map("<Cmd>bn<CR>", "<S-l>", "n", { desc = "Next buffer" })
map("<Cmd>bp<CR>", "<S-h>", "n", { desc = "Prev buffer" })
map("<Cmd>noh<CR><esc>", "<esc>", { "n", "t" }, { desc = "Esc + clear search highlight" })
map("<Cmd>set wrap!<CR>", "<leader>w", "n", { desc = "Toggle word wrap" })
map("<Cmd>tabclose<CR>", "<leader><tab>d", "n", { desc = "Close tab" })
map("<Cmd>tabn<CR>", "<leader><tab>n", "n", { desc = "Next tab" })
map("<Cmd>tabp<CR>", "<leader><tab>p", "n", { desc = "Previous tab" })
map("<Cmd>w<CR>", "<C-s>", "n", { desc = "Save file" })
map("gc", "<C-_>", "v", { desc = "Toggle comment", remap = true })
map("gcc", "<C-_>", "n", { desc = "Toggle comment", remap = true })
map("ggVG", "<C-a>", "n", { desc = "Select all" })
map('"+P', "<leader>P", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+p', "<leader>p", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+y', "<leader>y", { "n", "v" }, { desc = "Yank to clipboard" })

map(function()
	local topline = vim.fn.winsaveview().topline
	vim.cmd("norm zcV")
	vim.cmd("foldc!")
	vim.cmd("norm zvzc")
	vim.fn.winrestview({ topline = topline })
end, "zC", "n", { desc = "Fold all children" })

map(function()
	if vim.o.diffopt:find("iwhiteall") then
		vim.opt.diffopt:remove("iwhiteall")
	else
		vim.opt.diffopt:append("iwhiteall")
	end
end, "<leader>W", "n", { desc = "Toggle whitespace diff" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		map(vim.diagnostic.open_float, "<leader>ce", "n", { desc = "Diagnostics (floating)", buffer = ev.buf })
		map(vim.lsp.buf.code_action, "<leader>ca", { "n", "v" }, { desc = "Code action", buffer = ev.buf })
		map(vim.lsp.buf.hover, "K", "n", { desc = "Hover", buffer = ev.buf })
		map(vim.lsp.buf.rename, "<F2>", "n", { desc = "Rename", buffer = ev.buf })
		map(vim.lsp.buf.rename, "<leader>cr", "n", { desc = "Rename", buffer = ev.buf })
		map(function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
		end, "<leader>ci", "n", { desc = "Toggle inlay hint", buffer = ev.buf })
		map(function()
			vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
		end, "<leader>cd", "n", { desc = "Toggle diagnostics", buffer = ev.buf })
	end,
})
