return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		cmd = { "Mason" },
		keys = {
			{ "<Leader>m", "<Cmd>Mason<CR>", desc = "Mason" },
		},
		opts = {
			log_level = vim.g.log_level,
		},
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
				"spectral-language-server",
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
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.log.set_loglevel("error")
			require("luasnip.loaders.from_vscode").lazy_load()

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
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "FloatBorder:FloatBorder",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "FloatBorder:FloatBorder",
						max_width = 80,
					}),
				},
				formatting = {
					fields = { "kind", "abbr" },
					format = function(_, vim_item)
						if vim_item.menu and #vim_item.menu > 20 then
							vim_item.menu = string.sub(vim_item.menu, 1, 20) .. "…"
						end
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

			vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
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
				sql = { "pg_format" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_after_save = {
				lsp_format = "fallback",
			},
			formatters = {
				pg_format = { args = { "-u", "1", "-f", "1" } },
			},
			log_level = vim.g.log_level,
		},
	},
}
