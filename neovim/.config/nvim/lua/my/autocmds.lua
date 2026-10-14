vim.api.nvim_create_autocmd({ "VimResized" }, {
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function() vim.hl.hl_op() end,
})

vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("W", "w", {})

vim.api.nvim_create_user_command("CopyRelPath", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, {})
