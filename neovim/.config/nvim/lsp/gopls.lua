---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", ".git" },
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			-- Build
			directoryFilters = {
				"-.git",
				"-**/node_modules",
			},

			-- Formatting
			gofumpt = true,

			-- Completion
			usePlaceholders = true,

			-- Diagnostic
			analyses = {
				ST1000 = false, -- Incorrect or missing package comment
			},
			staticcheck = true,

			-- Inlayhint
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
