local utils = require("src.utils")
local M = {}

---@class Request
---@field method string
---@field target_url string
---@field headers string[]
---@field body string?

---@param request Request
local function curl_exec(request)
	local cmd = { "curl", "-i", "-s", "-X" .. request.method, request.target_url }
	for _, header in pairs(request.headers) do
		table.insert(cmd, "-H")
		table.insert(cmd, header)
	end
	if request.body then
		table.insert(cmd, "-d")
		table.insert(cmd, request.body)
	end

	local obj = vim.system(cmd, { text = true, timeout = 1000 })
	utils.write_cmd_output_to_split(obj, vim.fn.strftime("HTTP Response - %T"))
end

---@param node TSNode?
---@return TSNode
local function current_request_node(node)
	node = node or vim.treesitter.get_node()
	assert(node, "Invalid node.")
	assert(node:type() ~= "document", "No request definition under current cursor.")

	if node:type() == "request" then
		return node
	end
	return current_request_node(node:parent())
end

---@param node TSNode
---@return Request
local function parse_request_node(node)
	assert(node:type() == "request")

	local request = { headers = {} }

	for child, _ in node:iter_children() do
		local type = child:type()
		local text = vim.treesitter.get_node_text(child, 0)

		if type == "method" then
			request.method = text
		elseif type == "target_url" then
			request.target_url = text
		elseif type == "header" then
			table.insert(request.headers, vim.trim(text))
		else
			request.body = text
		end
	end

	return request
end

function M.run()
	local request = parse_request_node(current_request_node())
	curl_exec(request)
end

return M
