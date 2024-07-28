local psql = require("src.psql")
vim.api.nvim_buf_create_user_command(0, "Psql", function(opts)
	psql.query_paragraph(opts.fargs[1], opts.fargs[2])
end, { nargs = "*" })

local usql = require("src.usql")
vim.api.nvim_buf_create_user_command(0, "Usql", function(opts)
	usql.query_paragraph(opts.fargs[1], opts.fargs[2])
end, { nargs = "*" })

vim.keymap.set("n", "<leader>ql", usql.query_last, { desc = "Run query with last params", buffer = 0 })
