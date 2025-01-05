return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		enabled = true,
		--dependencies = { "hrsh7th/cmp-nvim-lsp" },
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			--			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			-- local capabilities = cmp_nvim_lsp.default_capabilities()
			--
			--

			-- On_attach function
			local on_attach = function(client, bufnr)
				local buf_map = function(mode, lhs, rhs, opts)
					opts = vim.tbl_extend("force", { buffer = bufnr }, opts or {})
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				-- Key bindings
				buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
				buf_map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })

				-- Format on save
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
						vim.lsp.buf.format({ async = true })
					end, { desc = "Format document with LSP" })

					vim.cmd([[
            augroup lsp_format_on_save
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
            augroup END
          ]])
				end
			end

			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			-- Define LSP servers
			local servers = { "lua_ls", "clangd", "rust_analyzer", "nil_ls" }

			for _, lsp in ipairs(servers) do
				local opts = {
					on_attach = on_attach,
					capabilities = capabilities,
				}
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if lsp == "lua_ls" then
					opts.settings = {
						Lua = {
							format = { enable = true },
							diagnostics = { globals = { "vim" } },
						},
					}
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				elseif lsp == "rust_analyzer" then
					opts.settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
							--diagnostics = { enable = true },
							formatting = { enable = true },
						},
					}
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				elseif lsp == "nil_ls" then
					opts.settings = {
						["nil"] = {
							formatting = {
								command = { "nixfmt" }, -- Use nixpkgs-fmt for formatting
							},
						},
					}
				end

				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				-- common configs for all LSPs
				lspconfig[lsp].setup(opts)
			end
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end,
	},
}
