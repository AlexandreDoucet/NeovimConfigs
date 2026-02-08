-- lua/plugins/langs/python.lua

local diagnostics = "pyright" -- or "ruff"
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    -- Safely ensure python parser
    pcall(vim.cmd.TSInstall, 'python')
    pcall(vim.treesitter.start)
  end,
})

return {
  ---------------------------------------------------------------------------
  -- Treesitter parsers
  ---------------------------------------------------------------------------
  -- Rust & related Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },
  ---------------------------------------------------------------------------
  -- Mason: ensure Python tooling
  ---------------------------------------------------------------------------
  --{
  --  "williamboman/mason-tool-installer.nvim",
  --  dependencies = { "mason-org/mason.nvim" },
  --  opts = {
  --    ensure_installed = {
  --      "pyright",
  --      "ruff",
  --      "debugpy",
  --    },
  --    auto_update = false,
  --    run_on_start = true,
  --  },
  --},

  ---------------------------------------------------------------------------
  -- Python LSP (pyright + ruff)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    ft = { "python" },
    opts = {
      servers = {
        pyright = {
          enabled = diagnostics == "pyright",
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },

        ruff = {
          enabled = diagnostics == "ruff",
          init_options = {
            settings = {
              args = {},
            },
          },
        },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Python test integration (pytest)
  ---------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
        },
      },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
    },
  },

  ---------------------------------------------------------------------------
  -- Python-specific polish
  ---------------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    ft = { "python" },
    opts = {
      auto_refresh = true,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap-python",
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python")
    end,
  }
}
