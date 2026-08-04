---@param line integer
---@param with_subtest boolean
---@return string, string
local function find_nearest_test(line, with_subtest)
	local package = vim.fn.fnamemodify(vim.fn.bufname(), ":.:h")
	local utils = require("utils")
	local subtest_patterns = {
		'%s+name:%s+"(.+)",$',
		'%s+t%.Run%("(.+)"',
	}

	while line > 0 do
		local text = utils.get_line_text(line)
		if text ~= "" and not vim.startswith(text, "\t") then
			local _, _, name = text:find("^func (Test.+)%(t %*testing%.T%) %{$")
			if not name then break end
			return package, "^" .. name .. "$"
		end

		if with_subtest then
			for _, pattern in ipairs(subtest_patterns) do
				local _, _, name = text:find(pattern)
				if name then
					local _, funcname = find_nearest_test(line - 1, false)
					return package, funcname .. "/^" .. vim.fn.escape(name:gsub(" ", "_"), "()[]{}.*+^$?'") .. "$"
				end
			end
		end

		line = line - 1
	end

	error("Test not found!", 0)
end

local last_cmd = "Run a test first! && exit 0"

---@param cmd string
local function run(cmd)
	last_cmd = cmd
	vim.cmd("hor te echo " .. cmd .. ' && echo "" && ' .. cmd)
	vim.keymap.set("n", "q", "iq", { buf = 0 })
end

local M = {}

function M.test_nearest()
	local package, testname = find_nearest_test(vim.api.nvim_win_get_cursor(0)[1], true)
	run("gotestsum -f testdox -- ./" .. package .. " -run='" .. testname .. "'")
end

function M.test_nearest_nocache()
	local package, testname = find_nearest_test(vim.api.nvim_win_get_cursor(0)[1], true)
	run("gotestsum -f testdox -- ./" .. package .. " -count=1 -run='" .. testname .. "'")
end

function M.debug_nearest_test()
	local _, testname = find_nearest_test(vim.api.nvim_win_get_cursor(0)[1], true)
	vim.notify("Starting debugger...")
	require("dap").run({
		type = "go",
		name = "Debug test",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		args = { "-test.run", testname },
		outputMode = "remote",
	})
end

function M.test_all() run("gotestsum --format-hide-empty-pkg") end
function M.test_all_nocache() run("gotestsum --format-hide-empty-pkg -- -count=1 ./...") end
function M.test_last() run(last_cmd) end

return M
