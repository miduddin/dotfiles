vim.diagnostic.config({
	float = { border = vim.g.border },
	jump = { float = true },
})
vim.lsp.set_log_level(vim.g.log_level)

return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		keys = {
			{ "<Leader>m", "<Cmd>Mason<CR>", desc = "Mason" },
		},
		opts = {
			log_level = vim.g.log_level,
			ui = { border = vim.g.border },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
		},
		opts = {
			basedpyright = {},
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
			ruff = {},
			rust_analyzer = {},
			tailwindcss = { filetypes = { "html" } },
			taplo = {},
			golangci_lint_ls = {},
			ts_ls = {},
			gopls = {
				settings = {
					gopls = {
						gofumpt = true,
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
							unusedwrite = true,
							useany = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						directoryFilters = {
							"-.git",
							"-node_modules",
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("lspconfig.ui.windows").default_options.border = vim.g.border

			local lspconfig = require("lspconfig")
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(
					vim.lsp.handlers.hover,
					{ border = vim.g.border, max_width = 80 }
				),
				["textDocument/signatureHelp"] = vim.lsp.with(
					vim.lsp.handlers.signature_help,
					{ border = vim.g.border, max_width = 80 }
				),
			}

			for k, v in pairs(opts) do
				lspconfig[k].setup({
					capabilities = require("blink.cmp").get_lsp_capabilities(v),
					handlers = handlers,
				})
			end
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		opts = {
			ensure_installed = {
				"basedpyright",
				"delve",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"golangci-lint-langserver",
				"gopls",
				"html-lsp",
				"intelephense",
				"json-lsp",
				"lua-language-server",
				"php-cs-fixer",
				"php-debug-adapter",
				"prettier",
				"ruff",
				"rust-analyzer",
				"sqlfluff",
				"sqlfmt",
				"stylua",
				"tailwindcss-language-server",
				"taplo",
				"typescript-language-server",
				"yaml-language-server",
				"yamlfmt",
			},
			run_on_start = false,
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		event = { "InsertEnter" },
		version = "v0.*",
		opts = {
			highlight = { use_nvim_cmp_as_default = true },
			keymap = {
				preset = "default",
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-K>"] = { "select_prev", "fallback" },
				["<C-J>"] = { "select_next", "fallback" },
			},
			trigger = { signature_help = { enabled = true } },
			windows = {
				autocomplete = {
					border = vim.g.border,
				},
				documentation = {
					auto_show = true,
					border = vim.g.border,
				},
				signature_help = {
					border = vim.g.border,
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<Leader>cf", [[<Cmd>lua require("conform").format({timeout_ms = 5000})<CR>]], desc = "Format buffer" },
		},
		opts = {
			formatters_by_ft = {
				css = { "prettier" },
				go = { "goimports", "gofumpt" },
				lua = { "stylua" },
				php = { "php_cs_fixer" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				sql = { "sqlfmt", "sqlfluff" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_after_save = {
				lsp_format = "fallback",
			},
			formatters = {
				sqlfluff = { require_cwd = false },
			},
			log_level = vim.g.log_level,
		},
	},
}
