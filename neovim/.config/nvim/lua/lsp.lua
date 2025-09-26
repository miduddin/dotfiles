vim.diagnostic.config({
	jump = { float = true },
	virtual_text = true,
	float = { source = true },
})
vim.lsp.set_log_level(vim.g.log_level)
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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
