vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.log_level = vim.log.levels.OFF
vim.g.mapleader = " "

vim.opt.breakindent = true
vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.diffopt:append({ "algorithm:patience", "linematch:70" })
vim.opt.expandtab = false
vim.opt.fillchars:append({ eob = " ", diff = "╱" })
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldtext = ""
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars:append({ tab = "│  ", trail = "█" })
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.shada = ""
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.wrap = false

vim.opt.foldmethod = "indent"
vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function(ev)
		if require("nvim-treesitter.parsers").has_parser() then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end,
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/foldingRange") then
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
