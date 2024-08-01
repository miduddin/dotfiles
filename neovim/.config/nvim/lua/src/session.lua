vim.opt.sessionoptions = {}

---@return string
local function session_file()
	local dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions", vim.fn.getcwd())
	vim.fn.mkdir(dir, "p")
	return vim.fs.joinpath(dir, "session.vim")
end

local function save_session()
	if vim.fn.argc() == 0 then
		vim.cmd("mks! " .. session_file())
	end
end
vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_session })

local function load_session()
	vim.cmd("so " .. session_file())
end

vim.keymap.set("n", "<Leader>sl", load_session, { desc = "Load last session" })
