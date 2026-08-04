---@param linenr integer
---@param with_subtest boolean
---@return string
local function find_nearest_test(linenr, with_subtest)
	local utils = require("utils")
	local subtest_patterns = {
		'\t+name:%s+"(.+)",$',
		'\t+t%.Run%("(.+)"',
		'\t+s%.Run%("(.+)"',
	}

	while linenr > 0 do
		local text = utils.get_line(linenr)
		if text ~= "" and not vim.startswith(text, "\t") then
			local _, _, name = text:find("^func (Test.+)%(t %*testing%.T%) %{$")
			if name then return "^" .. name .. "$" end

			local _, _, suite, name2 = text:find("^func %(.+*(.+)%) (Test.+)%(%) %{$")
			if suite and name2 then return suite .. "/^" .. name2 .. "$" end

			break
		end

		if with_subtest then
			for _, pattern in ipairs(subtest_patterns) do
				local _, _, name = text:find(pattern)
				if name then
					local funcname = find_nearest_test(linenr - 1, false)
					return funcname .. "/^" .. vim.fn.escape(name, "()[]{}.*+^$?") .. "$"
				end
			end
		end

		linenr = linenr - 1
	end

	error("Test not found!", 0)
end

---@type string[]?
local last_cmd = nil

---@param cmd string[]
local function run_test(cmd)
	last_cmd = cmd
	local win = require("utils").write_cmd_output_to_split("go test", cmd)
	vim.fn.matchadd("Added", "✓\\|PASS", 10, -1, { window = win })
	vim.fn.matchadd("Removed", "✖\\|FAIL", 10, -1, { window = win })
end

local M = {}

function M.test_nearest()
	local testname = find_nearest_test(vim.pos.cursor().row, true)
	run_test({ "gotestsum", "-f=testdox", "--", "./" .. vim.fn.expand("%:.:h"), "-run", testname })
end
function M.test_nearest_nocache()
	local testname = find_nearest_test(vim.pos.cursor().row, true)
	run_test({ "gotestsum", "-f=testdox", "--", "./" .. vim.fn.expand("%:.:h"), "-run", testname, "-count=1" })
end

function M.test_function()
	local testname = find_nearest_test(vim.pos.cursor().row, false)
	run_test({ "gotestsum", "-f=testdox", "--", "./" .. vim.fn.expand("%:.:h"), "-run", testname })
end
function M.test_function_nocache()
	local testname = find_nearest_test(vim.pos.cursor().row, false)
	run_test({ "gotestsum", "-f=testdox", "--", "./" .. vim.fn.expand("%:.:h"), "-run", testname, "-count=1" })
end

function M.test_all() run_test({ "gotestsum", "--format-hide-empty-pkg" }) end
function M.test_all_nocache() run_test({ "gotestsum", "--format-hide-empty-pkg", "--", "./...", "-count=1" }) end

function M.test_last()
	if last_cmd then run_test(last_cmd) end
end

function M.debug_nearest_test()
	local testname = find_nearest_test(vim.pos.cursor().row, true)
	vim.notify("Starting debugger...")
	require("dap").run({
		type = "go",
		name = "Debug test",
		request = "launch",
		mode = "test",
		program = vim.fn.expand("%:p:h"),
		args = { "-test.run", testname },
		outputMode = "remote",
	})
end

return M
