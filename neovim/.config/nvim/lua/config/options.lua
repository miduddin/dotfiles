vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.log_level = vim.log.levels.OFF
vim.g.mapleader = " "
vim.g.clipboard = {
	name = "WSL Clipboard",
	copy = {
		["+"] = "clip.exe",
		["*"] = "clip.exe",
	},
	paste = {
		["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	},
}

vim.opt.breakindent = true
vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.diffopt:append({ "algorithm:patience", "linematch:70" })
vim.opt.expandtab = false
vim.opt.fillchars = { eob = " ", diff = " ", stl = "─", stlnc = "─" }
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars:append({ space = "·", tab = "  " })
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.sessionoptions:append("globals")
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wrap = false
