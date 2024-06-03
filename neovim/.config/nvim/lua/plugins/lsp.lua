vim.diagnostic.config({
	float = { border = "rounded" },
	jump = { float = true },
})

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
		opts = {
			jsonls = {},
			yamlls = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},
					},
				},
			},
			html = {},
			lua_ls = {},
			intelephense = {},
			rust_analyzer = {},
			spectral = { settings = { rulesetFile = ".spectral.yaml" } },
			tailwindcss = { filetypes = { "html" } },
			taplo = {},
			golangci_lint_ls = {},
			tsserver = {},
			gopls = {
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
			},
		},
		config = function(_, opts)
			require("lspconfig.ui.windows").default_options.border = "single"

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			for k, v in pairs(opts) do
				lspconfig[k].setup(vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					handlers = handlers,
				}, v))
			end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

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

			local global_snippets = {
				-- { trigger = "lorem", body = '"lorem ipsum dolor sit amet"' },
			}

			local ft_snippets = {
				go = {
					{ trigger = "func", body = "func ${1:name}(${2:args}) {\n\t$0\n}" },
					{ trigger = "meth", body = "func (${1:recv}) ${2:name}(${3:args}) {\n\t$0\n}" },
				},
			}

			local function get_buf_snips()
				local ft = vim.bo.filetype
				local snips = vim.list_slice(global_snippets)

				if ft and ft_snippets[ft] then
					vim.list_extend(snips, ft_snippets[ft])
				end

				return snips
			end

			local cmp_source = {}
			local cache = {}
			function cmp_source.complete(_, _, callback)
				local bufnr = vim.api.nvim_get_current_buf()
				if not cache[bufnr] then
					local completion_items = vim.tbl_map(function(s)
						local item = {
							word = s.trigger,
							label = s.trigger,
							kind = vim.lsp.protocol.CompletionItemKind.Snippet,
							insertText = s.body,
							insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
						}
						return item
					end, get_buf_snips())

					cache[bufnr] = completion_items
				end

				callback(cache[bufnr])
			end

			cmp.register_source("custom_snippets", cmp_source)

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
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
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "custom_snippets" },
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
				sql = { "sqlfmt", "sqlfluff" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_after_save = {
				lsp_fallback = true,
			},
			formatters = {
				yamlfmt = { args = { "-formatter", "line_ending=lf,scan_folded_as_literal=true", "-" } },
				sqlfluff = { args = { "fix", "-" } },
			},
		},
	},
}
