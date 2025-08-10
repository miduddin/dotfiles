vim.cmd("colorscheme vague-custom")
require("src")
vim.schedule(function() require("plugins") end)
