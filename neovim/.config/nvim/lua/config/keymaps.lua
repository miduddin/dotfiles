-- reorder arguments just so it looks better when sorted.
local map = function(rhs, lhs, mode, opts) vim.keymap.set(mode, lhs, rhs, opts) end

map("*``", "*", "n", { desc = "Search current word without going next" })
map("5j", "<C-J>", { "n", "v" }, { desc = "5 line down" })
map("5k", "<C-K>", { "n", "v" }, { desc = "5 line up " })
map("<Cmd>Lazy<CR>", "<Leader>l", "n", { desc = "Lazy" })
map("<Cmd>bn<CR>", "<S-L>", "n", { desc = "Next buffer" })
map("<Cmd>bp<CR>", "<S-H>", "n", { desc = "Prev buffer" })
map("<Cmd>cnext<CR>", "]q", "n", { desc = "Next quickfix item" })
map("<Cmd>cprev<CR>", "[q", "n", { desc = "Previous quickfix item" })
map("<Cmd>noh<CR><Esc>", "<Esc>", { "n", "t" }, { desc = "Esc + clear search highlight" })
map("<Cmd>set wrap!<CR>", "<Leader>w", "n", { desc = "Toggle word wrap" })
map("<Cmd>tabclose<CR>", "<Leader><tab>d", "n", { desc = "Close tab" })
map("<Cmd>tabn<CR>", "<Leader><Tab>n", "n", { desc = "Next tab" })
map("<Cmd>tabp<CR>", "<Leader><Tab>p", "n", { desc = "Previous tab" })
map("<Cmd>w<CR>", "<C-S>", "n", { desc = "Save file" })
map("gc", "<C-_>", "v", { desc = "Toggle comment", remap = true })
map("gcc", "<C-_>", "n", { desc = "Toggle comment", remap = true })
map("ggVG", "<C-A>", "n", { desc = "Select all" })
map('"+P', "<Leader>P", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+p', "<Leader>p", { "n", "v" }, { desc = "Paste from clipboard" })
map('"+y', "<Leader>y", { "n", "v" }, { desc = "Yank to clipboard" })

map(function()
	local topline = vim.fn.winsaveview().topline
	vim.cmd("norm zcV")
	vim.cmd("foldc!")
	vim.cmd("norm zvzc")
	vim.fn.winrestview({ topline = topline })
end, "zC", "n", { desc = "Fold all children" })

map(function()
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end, "<Leader>q", "n", { desc = "Toggle quickfix list" })

map(function()
	if vim.o.diffopt:find("iwhiteall") then
		vim.opt.diffopt:remove("iwhiteall")
	else
		vim.opt.diffopt:append("iwhiteall")
	end
end, "<Leader>W", "n", { desc = "Toggle whitespace diff" })

map(function()
	if vim.o.diffopt:find("icase") then
		vim.opt.diffopt:remove("icase")
	else
		vim.opt.diffopt:append("icase")
	end
end, "<Leader>C", "n", { desc = "Toggle case-sensitive diff" })

map(function()
	if vim.api.nvim_get_option_value("diff", { scope = "local" }) then
		vim.cmd("diffo")
	else
		vim.cmd("difft")
	end
end, "<Leader>gw", "n", { desc = "Diff current window" })

map(function()
	if vim.api.nvim_get_option_value("diff", { scope = "local" }) then
		vim.cmd("windo diffo")
	else
		vim.cmd("windo difft")
	end
end, "<Leader>gW", "n", { desc = "Diff visible windows" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		map(vim.diagnostic.open_float, "<Leader>ce", "n", { desc = "Diagnostics (floating)", buffer = ev.buf })
		map(vim.diagnostic.setqflist, "<Leader>x", "n", { desc = "Diagnostics (quickfix list)" })
		map(vim.lsp.buf.code_action, "<Leader>ca", { "n", "v" }, { desc = "Code action", buffer = ev.buf })
		map(vim.lsp.buf.definition, "gd", { "n" }, { desc = "LSP definition" })
		map(vim.lsp.buf.hover, "K", "n", { desc = "Hover", buffer = ev.buf })
		map(vim.lsp.buf.implementation, "gi", { "n" }, { desc = "LSP implementations" })
		map(vim.lsp.buf.references, "gr", { "n" }, { desc = "LSP references" })
		map(vim.lsp.buf.rename, "<F2>", "n", { desc = "Rename", buffer = ev.buf })
		map(vim.lsp.buf.rename, "<Leader>cr", "n", { desc = "Rename", buffer = ev.buf })
		map(vim.lsp.buf.signature_help, "<C-S>", "i", { desc = "LSP signature help", buffer = ev.buf })
		map(vim.lsp.buf.type_definition, "gD", { "n" }, { desc = "LSP type definition" })
		map(
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
			end,
			"<Leader>ci",
			"n",
			{ desc = "Toggle inlay hint", buffer = ev.buf }
		)
		map(
			function() vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf }) end,
			"<Leader>cd",
			"n",
			{ desc = "Toggle diagnostics", buffer = ev.buf }
		)
	end,
})
