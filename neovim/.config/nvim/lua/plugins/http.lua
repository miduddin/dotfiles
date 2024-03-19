return {
	{
		"rest-nvim/rest.nvim",
		commit = "8b62563",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
		},
		ft = { "http" },
		keys = {
			{ "<leader>hr", '<cmd>lua require("rest-nvim").run()<cr>', desc = "Do HTTP request" },
		},
		opts = {
			result_split_horizontal = false,
			result_split_in_place = true,
			skip_ssl_verification = false,
			encode_url = true,
			highlight = {
				enabled = true,
				timeout = 150,
			},
			result = {
				show_url = true,
				show_curl_command = false,
				show_http_info = true,
				show_headers = true,
				formatters = {
					json = "jq",
					html = function(body)
						return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
					end,
				},
			},
			jump_to_request = false,
			env_file = ".env",
			custom_dynamic_variables = {},
			yank_dry_run = false,
		},
	},
}
