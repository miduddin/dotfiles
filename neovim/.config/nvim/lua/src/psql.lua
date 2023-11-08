local function run_query(query, pg_service, timeout_s)
	timeout_s = timeout_s or 3

	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)
	vim.keymap.set("n", "q", "<cmd>bd<cr>", { desc = "Close buffer", buffer = buf })

	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "# Running..." })
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.cmd("redraw")

	local input = {
		"\\set QUIET 1",
		"\\pset columns " .. (vim.api.nvim_win_get_width(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff),
		"set statement_timeout to " .. (timeout_s * 1000) .. ";",
		"\\timing on",
	}
	for _, v in pairs(query) do
		table.insert(input, v)
	end

	local result = vim.fn.system("PGCONNECT_TIMEOUT=" .. timeout_s .. " psql service=" .. pg_service, input)

	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.fn.split(result, "\n"))
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

local last_params = {
	pg_service = nil,
	timeout_s = nil,
}

local function query_paragraph(pg_service, timeout_s)
	last_params = {
		pg_service = pg_service,
		timeout_s = timeout_s,
	}
	local query_begin = vim.api.nvim_buf_get_mark(0, "(")[1]
	local query_end = vim.api.nvim_buf_get_mark(0, ")")[1]

	local query = vim.api.nvim_buf_get_lines(0, query_begin - 1, query_end, false)

	return run_query(query, pg_service, timeout_s)
end

local function query_last()
	if last_params.pg_service == nil or last_params.pg_service == "" then
		vim.notify("psql: no params recorded")
		return
	end
	query_paragraph(last_params.pg_service, last_params.timeout_s)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function(ev)
		vim.api.nvim_buf_create_user_command(ev.buf, "Psql", function(opts)
			query_paragraph(opts.fargs[1], opts.fargs[2])
		end, { nargs = "*" })

		vim.keymap.set("n", "<leader>ql", query_last, { desc = "Run query with last params", buffer = ev.buf })
	end,
})
