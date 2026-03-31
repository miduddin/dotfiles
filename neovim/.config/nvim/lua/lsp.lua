local last_float_bufnr = nil
vim.diagnostic.config({
	jump = {
		on_jump = function()
			if last_float_bufnr and vim.api.nvim_buf_is_valid(last_float_bufnr) then
				vim.api.nvim_buf_delete(last_float_bufnr, {})
			end
			last_float_bufnr, _ = vim.diagnostic.open_float()
		end,
	},
	virtual_text = true,
	float = { source = true },
})

vim.lsp.log.set_level(vim.g.log_level)
vim.lsp.enable({
	"buf",
	"golangci_lint_ls",
	"gopls",
	"lua_ls",
	"ruby_lsp",
	"rust_analyzer",
	"taplo",
	"ty",
	"zls",
})
