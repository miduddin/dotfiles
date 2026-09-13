require("my.options")
require("my.colors")
require("my.tabline")

vim.api.nvim_create_autocmd("FileType", {
	callback = function() pcall(vim.treesitter.start) end,
})

vim.schedule(function()
	require("vim._core.ui2").enable({})
	require("my.keymaps")
	require("my.autocmds")
	require("my.lsp")
	require("my.git")
	require("my.docker")
	require("my.session")
	require("my.dev")

	require("my.plugins")
end)
