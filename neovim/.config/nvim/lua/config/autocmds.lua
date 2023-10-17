vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	command = "checktime",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	command = "wincmd =",
})
