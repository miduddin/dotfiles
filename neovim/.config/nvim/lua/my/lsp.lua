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
	float = {
		max_height = 10,
		max_width = 80,
		source = true,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then client.server_capabilities.semanticTokensProvider = nil end
	end,
})

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		if value.percentage == nil then return end
		vim.api.nvim_echo({ { value.title } }, false, {
			id = "my.lsp",
			kind = "progress",
			source = "vim.lsp",
			title = "LSP",
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

vim.lsp.log.set_level(vim.g.log_level)
vim.lsp.enable({
	"buf",
	"clangd",
	"golangci_lint_ls",
	"gopls",
	"lua_ls",
	"ruby_lsp",
	"rust_analyzer",
	"tsc",
	"ty",
	"zls",
})
