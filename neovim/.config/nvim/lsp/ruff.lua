---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {},
}
