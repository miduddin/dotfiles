require("colors")
require("options")
require("tabline")

vim.api.nvim_create_autocmd("FileType", {
	callback = function() pcall(vim.treesitter.start) end,
})

vim.schedule(function()
	require("vim._core.ui2").enable({})
	require("keymaps")
	require("autocmds")
	require("lsp")
	require("git")
	require("docker")
	require("session")

	require("plugins")
end)
