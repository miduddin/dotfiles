vim.diagnostic.config({ float = { border = "rounded" } })

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		keys = {
			{ "<leader>m", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = { ui = { border = "rounded" } },
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}
			local default_setup = {
				capabilities = capabilities,
				handlers = handlers,
			}

			local default_with = function(extra)
				return vim.tbl_deep_extend("force", default_setup, extra)
			end

			local lspconfig = require("lspconfig")

			lspconfig.jsonls.setup(default_setup)
			lspconfig.html.setup(default_setup)
			lspconfig.lua_ls.setup(default_setup)
			lspconfig.intelephense.setup(default_setup)
			lspconfig.rust_analyzer.setup(default_setup)
			lspconfig.spectral.setup(default_with({
				settings = {
					rulesetFile = ".spectral.yaml",
				},
			}))
			lspconfig.tailwindcss.setup(default_with({
				filetypes = { "html" },
			}))
			lspconfig.taplo.setup(default_setup)
			lspconfig.gopls.setup(default_with({
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						analyses = {
							fieldalignment = true,
							nilness = true,
							unusedparams = true,
							unusedvariable = true,
							unusedwrite = true,
							useany = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						directoryFilters = {
							"-.git",
							"-.vscode",
							"-.idea",
							"-.vscode-test",
							"-node_modules",
						},
					},
				},
			}))
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local kind_icons = {
				Class = "󰠱",
				Color = "󰏘",
				Constant = "󰏿",
				Constructor = "",
				Enum = "",
				EnumMember = "",
				Event = "",
				Field = "󰜢",
				File = "󰈙",
				Folder = "󰉋",
				Function = "󰊕",
				Interface = "",
				Keyword = "󰌋",
				Method = "󰆧",
				Module = "",
				Operator = "󰆕",
				Property = "󰜢",
				Reference = "󰈇",
				Snippet = "",
				Struct = "󰙅",
				Text = "󰉿",
				TypeParameter = "",
				Unit = "󰑭",
				Value = "󰎠",
				Variable = "󰀫",
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					format = function(entry, vim_item)
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
						vim_item.menu = ""
						return vim_item
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<leader>cf", [[<cmd>lua require("conform").format({timeout_ms = 5000})<cr>]], desc = "Format buffer" },
		},
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofumpt" },
				lua = { "stylua" },
				php = { "php_cs_fixer" },
				sql = { "sqlfmt" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_after_save = {
				lsp_fallback = true,
			},
			formatters = {
				yamlfmt = {
					args = { "-formatter", "line_ending=lf,scan_folded_as_literal=true", "-" },
				},
			},
		},
	},
}
