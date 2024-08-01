vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "term://*lazydocker",
	command = "startinsert | setlocal nonumber signcolumn=no",
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
	pattern = "term://*lazydocker",
	command = [[call feedkeys("k")]],
})

vim.keymap.set("n", "<Leader>/d", "<Cmd>tabnew | term lazydocker<CR>", { desc = "Lazydocker" })
