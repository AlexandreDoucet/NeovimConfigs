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
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "debugpy",
      })
    end,
  },

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
  -- Python DAP (debugpy)
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")

      dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("debugpy"),
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Debug current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
      }
    end,
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
}
