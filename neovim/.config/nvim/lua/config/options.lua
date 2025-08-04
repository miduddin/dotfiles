vim.g.loaded_2html_plugin = true
vim.g.loaded_fzf = true
vim.g.loaded_gzip = true
vim.g.loaded_man = true
vim.g.loaded_matchit = true
vim.g.loaded_netrw = true
vim.g.loaded_remote_plugins = true
vim.g.loaded_spec = true
vim.g.loaded_spellfile_plugin = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_zipPlugin = true
vim.g.log_level = vim.log.levels.OFF
vim.g.mapleader = " "

vim.opt.breakindent = true
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.diffopt:append({ "algorithm:patience", "linematch:70" })
vim.opt.fillchars:append({ diff = "╱" })
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars:append({ tab = "│  ", trail = "│" })
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.wrap = false

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
