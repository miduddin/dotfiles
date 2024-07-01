vim.opt_local.commentstring = "# %s"
vim.keymap.set("n", "<leader>r", require("src.http").run, { desc = "Run nearest HTTP request", buffer = 0 })
