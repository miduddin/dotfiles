vim.opt_local.commentstring = "-- %s"

local psql = require("src.psql")
vim.api.nvim_buf_create_user_command(0, "Psql", function(opts)
	psql.query_paragraph(opts.fargs[1], opts.fargs[2])
end, { nargs = "*" })

local usql = require("src.usql")
vim.api.nvim_buf_create_user_command(0, "Usql", function(opts)
	usql.query_paragraph(opts.fargs[1], opts.fargs[2])
end, { nargs = "*" })
