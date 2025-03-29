---@type vim.lsp.Config
return {
	cmd = { "spectral-language-server", "--stdio" },
	filetypes = { "yaml.openapi", "json.openapi" },
	settings = {
		enable = true,
		rulesetFile = ".spectral.yaml",
		run = "onType",
		validateLanguages = { "yaml.openapi", "json.openapi" },
	},
}
