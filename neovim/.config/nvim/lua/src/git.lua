vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = "term://*lazygit",
	command = "startinsert | setlocal nonu nornu signcolumn=no",
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
	pattern = "term://*lazygit",
	command = [[call feedkeys("k")]],
})

---@param cmd string
---@return string?
local function system(cmd)
	local result = vim.system(vim.split(cmd, " "), { text = true }):wait().stdout
	if result then return vim.trim(result) end
	return result
end

local function open_in_remote()
	local filepath = system("git ls-files --full-name " .. vim.api.nvim_buf_get_name(0))
	if not filepath then
		vim.notify("Error getting git filepath")
		return
	end

	local commit = system("git rev-parse --short HEAD")
	if not commit then
		vim.notify("Error getting current git commit")
		return
	end

	-- NOTE: only works with https remote.
	local remote = system("git config --get remote.origin.url")
	if not remote then
		vim.notify("Error getting git remote")
		return
	end
	remote = remote:gsub(".git$", "")

	local line_start, line_end = vim.fn.line("."), vim.fn.line("v")
	if line_end < line_start then
		line_start, line_end = line_end, line_start
	end

	local url = remote .. "/blob/" .. commit .. "/" .. filepath .. "#L" .. line_start
	if line_end ~= line_start then url = url .. "-L" .. line_end end

	vim.ui.open(url)
end

Map("<Leader>/g", "<Cmd>tabnew | term lazygit<CR>", "n", { desc = "Lazygit" })
Map("<Leader>gr", open_in_remote, { "n", "v" }, { desc = "Open in git remote" })
