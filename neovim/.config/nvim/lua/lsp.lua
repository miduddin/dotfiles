vim.diagnostic.config({
	jump = { float = true },
	virtual_text = true,
	float = { source = true },
	signs = false,
})
vim.lsp.log.set_level(vim.g.log_level)
vim.lsp.enable({
	"buf",
	"cssls",
	"golangci_lint_ls",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"ruby_lsp",
	"ruff",
	"rust_analyzer",
	"taplo",
	"ts_ls",
	"yamlls",
	"zls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
