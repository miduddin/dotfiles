-- From https://github.com/boltlessengineer/NativeVim/blob/dfe0f6764d083fb5b7911b973e1b96cb17a8d783/lua/util.lua
local function load_vim_libs(client)
	local path = vim.tbl_get(client, "workspace_folders", 1, "name")
	if not path then return end

	client.settings = vim.tbl_deep_extend("force", client.settings, {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
				},
			},
		},
	})
end

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	log_level = 2,
	on_init = load_vim_libs,
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			semantic = {
				enable = false,
			},
		},
	},
}
