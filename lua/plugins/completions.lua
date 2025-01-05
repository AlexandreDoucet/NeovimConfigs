return {
	{
		"saghen/blink.cmp",
		enabled = true,
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "default",

				["<ESC>"] = { "cancel", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-j>"] = { "select_prev", "fallback" },
				["<C-k>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				ghost_text = {
					enabled = true,
				},
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline" and not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				--cmdline = {},
			},
		},
		opts_extend = { "sources.default" },
	},

	--	-- cmp-nvim-lsp: LSP completion source for nvim-cmp
	--	{
	--		"hrsh7th/cmp-nvim-lsp",
	--		lazy = true, -- Lazy load when LSP client is initialized
	--		config = function()
	--			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	--			vim.lsp.handlers["textDocument/signatureHelp"] =
	--				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	--		end,
	--	},
	--
	--	-- LuaSnip with friendly snippets
	--	{
	--		"L3MON4D3/LuaSnip",
	--		dependencies = {
	--			"saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
	--			"rafamadriz/friendly-snippets", -- Community snippets collection
	--		},
	--		lazy = true, -- Lazy load LuaSnip
	--	},
	--
	--	-- nvim-cmp: Auto-completion plugin
	--	{
	--		"hrsh7th/nvim-cmp",
	--		config = function()
	--			local cmp = require("cmp")
	--			local luasnip = require("luasnip")
	--
	--			-- Load VSCode-style snippets lazily
	--			require("luasnip.loaders.from_vscode").lazy_load()
	--
	--			-- Configure nvim-cmp
	--			cmp.setup({
	--				snippet = {
	--					expand = function(args)
	--						luasnip.lsp_expand(args.body) -- Expand snippets with LuaSnip
	--					end,
	--				},
	--				window = {
	--					completion = cmp.config.window.bordered(),
	--					documentation = cmp.config.window.bordered(),
	--				},
	--				mapping = cmp.mapping.preset.insert({
	--					["<C-b>"] = cmp.mapping.scroll_docs(-4),
	--					["<C-f>"] = cmp.mapping.scroll_docs(4),
	--					["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
	--					["<C-e>"] = cmp.mapping.abort(), -- Close completion
	--					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
	--				}),
	--				sources = cmp.config.sources({
	--					{ name = "nvim_lsp" }, -- LSP completion
	--					{ name = "luasnip" }, -- Snippet completion
	--					{ name = "render-markdown" },
	--				}, {
	--					{ name = "buffer" }, -- Buffer source for word completion
	--					{ name = "path" }, -- Path source (for file names, etc.)
	--				}),
	--			})
	--		end,
	--	},
}
