return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
      ------------------------------------------------------------------
      -- LSP server definitions (Neovim 0.11 native)
      ------------------------------------------------------------------

      vim.lsp.config.lua_ls = {}
      vim.lsp.config.rust_analyzer = {}
      vim.lsp.config.clangd = {}
      vim.lsp.config.eslint = {}
      vim.lsp.config.jinja_lsp = {}
      vim.lsp.config.cssls = {}

      -- Enable servers
      vim.lsp.enable({
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "eslint",
        "jinja_lsp",
        "cssls",
      })

      ------------------------------------------------------------------
      -- Global diagnostic keymaps
      ------------------------------------------------------------------

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      ------------------------------------------------------------------
      -- LspAttach: buffer-local mappings
      ------------------------------------------------------------------

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          if not ev.buf or not vim.api.nvim_buf_is_valid(ev.buf) then
            return
          end

          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)

          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          vim.keymap.set("n", "<leader>gw", vim.diagnostic.goto_next, {
            buffer = ev.buf,
            desc = "Go to Next Diagnostic",
          })

          vim.keymap.set("n", "<leader>ge", function()
            vim.diagnostic.goto_next({
              severity = vim.diagnostic.severity.ERROR,
            })
          end, {
            buffer = ev.buf,
            desc = "Go to Next Error",
          })
        end,
      })
    end,
  },
}
