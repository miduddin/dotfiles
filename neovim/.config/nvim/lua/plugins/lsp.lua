local cmp = require("cmp")

local kinds = {
	Text = "󰉿 ",
	Method = "󰊕 ",
	Function = "󰊕 ",
	Constructor = "󰒓 ",
	Field = "󰜢 ",
	Variable = "󰆦 ",
	Property = "󰖷 ",
	Class = "󱡠 ",
	Interface = "󱡠 ",
	Struct = "󱡠 ",
	Module = "󰅩 ",
	Unit = "󰪚 ",
	Value = "󰦨 ",
	Enum = "󰦨 ",
	EnumMember = "󰦨 ",
	Keyword = "󰻾 ",
	Constant = "󰏿 ",
	Snippet = "󱄽 ",
	Color = "󰏘 ",
	File = "󰈔 ",
	Reference = "󰬲 ",
	Folder = "󰉋 ",
	Event = "󱐋 ",
	Operator = "󰪚 ",
	TypeParameter = "󰬛 ",
}

cmp.setup({
	snippet = {
		expand = function(args) vim.snippet.expand(args.body) end,
	},
	window = {
		completion = { winhighlight = "CursorLine:Visual" },
		documentation = { winhighlight = "" },
	},
	formatting = {
		fields = { "kind", "abbr" },
		format = function(_, vim_item)
			if vim_item.menu and #vim_item.menu > 20 then vim_item.menu = string.sub(vim_item.menu, 1, 20) .. "…" end
			vim_item.kind = kinds[vim_item.kind] or ""
			return vim_item
		end,
	},
	matching = {
		disallow_partial_fuzzy_matching = false,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-U>"] = cmp.mapping.scroll_docs(-4),
		["<C-D>"] = cmp.mapping.scroll_docs(4),
		["<C-J>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-K>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-E>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
	}),
})

vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

require("conform").setup({
	formatters_by_ft = {
		go = { "golangci-lint" },
		json = { "jq" },
		jsonc = { "jq" },
		lua = { "stylua" },
		php = { "php_cs_fixer" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		sql = { "pg_format" },
		terraform = { "terraform_fmt" },
		toml = { "taplo" },
		yaml = { "yamlfmt" },
		["*"] = { "trim_whitespace", "trim_newlines" },
		["_"] = { lsp_format = "last" },
	},
	format_after_save = true,
	log_level = vim.g.log_level,
})
