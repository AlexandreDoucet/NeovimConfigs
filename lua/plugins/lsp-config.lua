return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    enabled = true,
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Set up Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true, -- Automatically install LSPs
      })

      -- Set up global diagnostics configuration
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        float = {
          focusable = false,
          border = "rounded",
        },
      })

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
        vim.keymap.set("n", "<leader>gw", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })
        vim.keymap.set("n", "<leader>ge", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Go to Next Error" })
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

      -- Define LSP servers
      local servers = { "lua_ls", "clangd", "rust_analyzer", "nil_ls", "jedi_language_server" }

      for _, lsp in ipairs(servers) do
        local opts = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        if lsp == "lua_ls" then
          opts.settings = {
            Lua = {
              format = { enable = true },
              diagnostics = { globals = { "vim" } },
            },
          }
        elseif lsp == "rust_analyzer" then
          opts.settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              formatting = { enable = true },
              diagnostics = {
                disabled = { "unresolved-proc-macro", "inactive-code" },
              },
            },
          }
        elseif lsp == "nil_ls" then
          opts.settings = {
            ["nil"] = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          }
        elseif lsp == "pyright" then
          opts.settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          }
        end

        -- Setup LSP
        lspconfig[lsp].setup(opts)
      end

      -- Automatically configure installed LSPs from Mason
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
}
