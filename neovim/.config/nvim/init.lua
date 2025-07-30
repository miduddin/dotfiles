vim.cmd("colorscheme vague-custom")
require("config")
require("src")

vim.diagnostic.config({ jump = { float = true }, virtual_text = true })
vim.lsp.set_log_level(vim.g.log_level)
vim.lsp.enable({
	"golangci_lint_ls",
	"gopls",
	"html",
	"intelephense",
	"jsonls",
	"lua_ls",
	"pyright",
	"ruff",
	"rust_analyzer",
	"spectral",
	"taplo",
	"ts_ls",
	"yamlls",
})

vim.schedule(function() require("plugins") end)
