vim.opt_local.commentstring = "# %s"
vim.keymap.set("n", "<Leader>r", require("src.http").run, { desc = "Run nearest HTTP request", buffer = 0 })
