--
--
--
-- lua/plugins/langs/rust.lua
local diagnostics = "rust-analyzer"

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  callback = function()
    -- Safely ensure rust parser
    pcall(vim.cmd.TSInstall, 'rust')
    pcall(vim.treesitter.start)
  end,
})



return {
  -- Crates.toml helper
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = false, actions = true, completion = true, hover = true },
    },
  },

  -- Rust & related Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- Ensure codelldb is installed
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  -- Rust tools and LSP
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          local keymap_opts = { desc = "Rust Action", buffer = bufnr }

          -- Rust code actions
          vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end,
            vim.tbl_extend("force", keymap_opts, { desc = "Code Action" }))

          -- Rust debuggables
          vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end,
            vim.tbl_extend("force", keymap_opts, { desc = "Rust Debuggables" }))
        end,

        default_settings = {
          ["rust-analyzer"] = {
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" }, -- <--- add this
            cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
            checkOnSave = diagnostics == "rust-analyzer",
            diagnostics = { enable = diagnostics == "rust-analyzer" },
            procMacro = { enable = true },
            files = {
              exclude = {
                ".direnv", ".git", ".jj", ".github", ".gitlab", "bin",
                "node_modules", "target", "venv", ".venv",
              },
              watcher = "client",
            },
          },
        },
      },
    },


    config = function(_, opts)
      local function get_rust_package_name()
        local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"
        local f = io.open(cargo_toml, "r")
        if not f then return nil end

        for line in f:lines() do
          local name = line:match('^name%s*=%s*"(.-)"')
          if name then
            f:close()
            return name
          end
        end

        f:close()
        return nil
      end

      -- DAP setup
      local has_mason = pcall(require, "mason")
      if has_mason then
        local dap = require("dap")
        local codelldb = vim.fn.exepath("codelldb")
        local codelldb_lib_ext = vim.loop.os_uname().sysname == "Linux" and ".so" or ".dylib"
        local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)

        opts.dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
        }

        dap.adapters.lldb = opts.dap.adapter

        dap.configurations.rust = {
          {
            type = "lldb",
            request = "launch",
            name = "Debug Rust",
            preLaunchTask = function()
              local package_name = get_rust_package_name()
              if package_name then
                vim.fn.system("cargo build --package " .. package_name .. " --bin " .. package_name .. " --all-features")
              end
            end,
            program = function()
              local package_name = get_rust_package_name() or "unknown"
              local default_path = vim.fn.getcwd() .. "/target/debug/" .. package_name
              return vim.fn.input("Path to executable: ", default_path, "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            initCommands = function()
              local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")
              local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
              local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
              return {
                ([[command script import '%s']]):format(script_file),
                ([[command source '%s']]):format(commands_file),
              }
            end,
          },
        }
      end

      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})

      -- Check for rust-analyzer
      if vim.fn.executable("rust-analyzer") == 0 then
        vim.notify(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          vim.log.levels.ERROR
        )
      end
    end,
  },

  -- Ensure rust_analyzer LSP in lspconfig is disabled if using rustaceanvim
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = { enabled = false },
      },
    },
  },

  -- Rust Neotest integration
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
}
