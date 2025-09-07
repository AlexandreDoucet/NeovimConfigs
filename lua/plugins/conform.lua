return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					nix = { "nixpkgs_fmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					jinja = { "djlint" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
	{
		"lepture/vim-jinja", -- Jinja syntax highlighting plugin
		ft = { "jinja", "htmldjango" }, -- Load only for relevant filetypes
	},
}
