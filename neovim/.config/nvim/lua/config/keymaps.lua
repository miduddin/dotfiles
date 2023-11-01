local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

map({ "n", "t" }, "<esc>", "<cmd>noh<cr><esc>")
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line up" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line down" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "*", "*``")
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>w", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from clipboard" })
map({ "i", "t" }, "<M-BS>", "<C-w>", { desc = "Delete word" })
map("n", "<S-h>", "<cmd>bp<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close current buffer" })
map("n", "<leader>bD", "<cmd>kT|%bd|e#|bd#|'T<cr>", { desc = "Close all other buffers" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Diagnostics (floating)" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostics item" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostics item" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Handle these with trouble.nvim
		-- map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration", buffer = ev.buf })
		-- map("n", "gd", vim.lsp.buf.definition, { desc = "Definition", buffer = ev.buf })
		-- map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation", buffer = ev.buf })
		-- map("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = ev.buf })
		-- map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition", buffer = ev.buf })
		map("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = ev.buf })
		map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
		map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = ev.buf })
		map("n", "<leader>ci", "<cmd>lua vim.lsp.inlay_hint(0)<cr>", { desc = "Toggle inlay hint", buffer = ev.buf })
	end,
})
