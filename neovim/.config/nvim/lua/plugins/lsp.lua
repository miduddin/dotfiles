vim.diagnostic.config({ float = { border = "rounded" } })
require("vim.lsp._watchfiles")._watchfunc = function(_, _, _)
	return true
end

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
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
			-- { "folke/neodev.nvim", opts = {} },
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

			local default_handler = function(extra)
				extra = extra or {}
				return vim.tbl_deep_extend("force", default_setup, extra)
			end

			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup(default_handler())
			lspconfig.intelephense.setup(default_handler())
			lspconfig.tsserver.setup(default_handler())
			lspconfig.terraformls.setup(default_handler())
			lspconfig.taplo.setup(default_handler())
			lspconfig.jsonls.setup(default_handler())
			lspconfig.rust_analyzer.setup(default_handler())
			lspconfig.gopls.setup(default_handler({
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
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
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
					{ name = "luasnip" },
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
			{ "<leader>cf", [[<cmd>lua require("conform").format()<cr>]], desc = "Format buffer" },
		},
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofumpt" },
				html = { { "prettierd" } },
				javascript = { { "prettierd" } },
				json = { "jq" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				php = { "php_cs_fixer" },
				sql = { "sqlfmt" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 5000,
			},
			formatters = {
				yamlfmt = {
					args = { "-formatter", "line_ending=lf,scan_folded_as_literal=true", "-" },
				},
				sqlfmt = {
					command = "sqlfmt",
					args = { "-" },
					stdin = true,
				},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				go = { "golangcilint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
