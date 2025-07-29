---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml" },
	settings = {},
	on_attach = function(client, _) client.server_capabilities.semanticTokensProvider = nil end,
}
