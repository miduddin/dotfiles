vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "term://*lazydocker",
	command = "startinsert | setlocal nonu nornu signcolumn=no",
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
	pattern = "term://*lazydocker",
	command = [[call feedkeys("k")]],
})

Map("<Leader>/d", "<Cmd>tabnew | term lazydocker<CR>", "n", { desc = "Lazydocker" })
