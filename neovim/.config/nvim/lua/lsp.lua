vim.diagnostic.config({
	jump = { float = true },
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
