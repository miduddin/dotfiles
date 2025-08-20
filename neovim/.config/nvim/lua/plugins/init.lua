local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/echasnovski/mini.deps",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.deps | helptags ALL")
	vim.cmd('echo "Installed `mini.deps`" | redraw')
end

local deps = require("mini.deps")
deps.setup({ path = { package = path_package } })

deps.add({ source = "nvim-treesitter/nvim-treesitter", hooks = { post_checkout = function() vim.cmd("TSUpdate") end } })
deps.add({ source = "nvim-treesitter/nvim-treesitter-textobjects", depends = { "nvim-treesitter/nvim-treesitter" } })
deps.add({ source = "nvim-treesitter/nvim-treesitter-context", depends = { "nvim-treesitter/nvim-treesitter" } })
deps.add({ source = "echasnovski/mini.surround" })
deps.add({ source = "jake-stewart/multicursor.nvim" })
deps.add({ source = "ibhagwan/fzf-lua" })
deps.add({ source = "sindrets/diffview.nvim" })
deps.add({
	source = "hrsh7th/nvim-cmp",
	depends = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
	},
})
deps.add({ source = "stevearc/conform.nvim" })
deps.add({
	source = "nvim-neotest/neotest",
	depends = {
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"fredrikaverpil/neotest-golang",
	},
})
deps.add({ source = "mfussenegger/nvim-dap" })
deps.add({ source = "stevearc/oil.nvim" })

require("plugins.treesitter")
require("plugins.editor")
require("plugins.finder")
require("plugins.git")
require("plugins.lsp")
require("plugins.test")
