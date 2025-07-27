vim.cmd("colorscheme kanagawa-custom")

require("config.options")
require("src")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } },
	dev = { path = "~/code" },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	rocks = { enabled = false },
})

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

require("config.keymaps")
require("config.autocmds")
