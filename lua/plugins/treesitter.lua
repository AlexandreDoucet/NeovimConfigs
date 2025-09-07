-- If this plugin throws an error, then run this command with the correct username and group to fix it. It iw probably caused bu the root user creating the repository first.
--sudo chown adoucet:users ~/.local/share/nvim/lazy/nvim-treesitter/parser
--
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	enabled = true,

	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			auto_install = true,
			ensure_installed = { "c", "lua", "html", "css", "javascript", "python" },
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "jinja" },
			},
			indent = { enable = true },

			completion = {
				enable = true, -- Enable completion source from Treesitter
			},
		})
	end,
}
