vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.log_level = vim.log.levels.OFF
vim.g.mapleader = " "

local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures

vim.opt.breakindent = true
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.fillchars:append({ diff = "╱" })
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.history = 100
vim.opt.ignorecase = true
vim.opt.isfname:append("@-@")
vim.opt.list = true
vim.opt.listchars:append({ tab = "│ ", trail = "│" })
vim.opt.loadplugins = false
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.shada = "'0,<1,s10,h"
vim.opt.shiftwidth = 4
vim.opt.showbreak = ".."
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.winborder = "rounded"
vim.opt.wrap = false

vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-2-
]])
