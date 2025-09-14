vim.opt.sessionoptions = "buffers,curdir,folds,help,winsize,tabpages"

---@return string
local function session_file()
	local dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")
	vim.fn.mkdir(dir, "p")

	local cwd = vim.fn.getcwd()
	local sessid = vim.fn.sha256(cwd) .. "_" .. vim.fn.fnamemodify(cwd, ":t")

	return vim.fs.joinpath(dir, sessid .. ".vim")
end

local function save_session()
	if vim.fn.argc() == 0 then vim.cmd("mks! " .. session_file()) end
end
vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_session })

local function load_session() vim.cmd("so " .. session_file()) end

Map("<Leader>sl", load_session, "n", { desc = "Load last session" })
