vim.diagnostic.config({
	jump = { float = true },
	virtual_text = true,
	float = { source = true },
})
vim.lsp.log.set_level(vim.g.log_level)
vim.lsp.enable({
	"cssls",
	"golangci_lint_ls",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"ruff",
	"rust_analyzer",
	"taplo",
	"ts_ls",
	"yamlls",
})
