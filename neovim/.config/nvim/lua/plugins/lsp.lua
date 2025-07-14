return {
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
		opts = {
			formatters_by_ft = {
				css = { "prettier" },
				go = { "golangci-lint" },
				lua = { "stylua" },
				php = { "php_cs_fixer" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				sql = { "pg_format" },
				terraform = { "terraform_fmt" },
				yaml = { "yamlfmt" },
				["*"] = { "trim_whitespace", "trim_newlines" },
				["_"] = { lsp_format = "last" },
			},
			format_after_save = true,
			log_level = vim.g.log_level,
		},
	},
}
