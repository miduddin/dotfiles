vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "term://*lazygit",
	command = "startinsert | setlocal nonumber signcolumn=no",
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
	pattern = "term://*lazygit",
	command = [[call feedkeys("k")]],
})

vim.keymap.set("n", "<Leader>/g", "<Cmd>tabnew | term lazygit<CR>", { desc = "Lazygit" })
