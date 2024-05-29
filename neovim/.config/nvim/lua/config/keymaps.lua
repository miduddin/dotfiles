local map = vim.keymap.set

map({ "n", "t" }, "<esc>", "<Cmd>noh<CR><esc>")

map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("n", "<C-s>", "<Cmd>w<CR>", { desc = "Save file" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "*", "*``")
map("n", "<leader><tab>d", "<Cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader><tab>n", "<Cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader><tab>p", "<Cmd>tabp<CR>", { desc = "Previous tab" })
map("n", "<leader>w", "<Cmd>set wrap!<CR>", { desc = "Toggle word wrap" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from clipboard" })

map("n", "<S-h>", "<Cmd>bp<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<Cmd>bn<CR>", { desc = "Next buffer" })
-- Handle with nvim-bufdel:
-- map("n", "<leader>bd", "<Cmd>bd<CR>", { desc = "Close current buffer" })
-- map("n", "<leader>bD", "<Cmd>kT|%bd|e#|bd#|'T<CR>", { desc = "Close all other buffers" })

map("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })

map("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Diagnostics (floating)" })

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
		map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help", buffer = ev.buf })
		map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
		map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = ev.buf })
		map("n", "<leader>ci", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, { desc = "Toggle inlay hint", buffer = ev.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help" },
	callback = function(ev)
		map("n", "q", "<Cmd>helpc<CR>", { buffer = ev.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf" },
	callback = function(ev)
		map("n", "q", "<Cmd>cclose<CR>", { buffer = ev.buf })
	end,
})

-- stylua: ignore start
map("n", "<leader>/g", function() os.execute("zellij run -c -i -- lazygit") end)
map("n", "<leader>/d", function() os.execute("zellij run -c -i -- lazydocker") end)
-- stylua: ignore end
