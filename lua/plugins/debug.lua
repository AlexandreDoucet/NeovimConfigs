return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support for multiple languages",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<F9>",       function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Run/Continue" },
      { "<F5>",       function() require("dap").continue() end,                                             desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<F6>",       function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<F11>",      function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<S-F11>",    function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<F10>",      function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
      { "<leader>du", function() require("dapui").toggle() end,                                             desc = "Toggle DAP UI" },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Highlight for stopped lines
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- DAP signs
      local dap_signs = {
        Breakpoint = { "", "DiagnosticError" },
        Stopped = { "", "DiagnosticWarn" },
      }
      for name, sign in pairs(dap_signs) do
        vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2], linehl = "", numhl = "" })
      end

      -- -----------------------
      -- Python Adapter
      -- -----------------------
      local function get_python_path()
        local venv = vim.fn.finddir("pyenv", vim.fn.getcwd() .. ";")
        if venv ~= "" then
          return venv .. "/bin/python"
        end
        return "python"
      end

      dap.adapters.python = {
        type = "executable",
        command = get_python_path(),
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          name = "Launch Python File",
          type = "python",
          request = "launch",
          program = "${file}",
          pythonPath = get_python_path(),
        },
      }

      -- -----------------------
      -- Rust Adapter (codelldb)
      -- -----------------------
      --dap.adapters.lldb = {
      --  type = 'executable',
      --  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
      --  name = 'lldb'
      --}

      --dap.configurations.rust = {
      --  {
      --    -- ... the previous config goes here ...,
      --    initCommands = function()
      --      -- Find out where to look for the pretty printer Python module.
      --      local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
      --      assert(
      --        vim.v.shell_error == 0,
      --        'failed to get rust sysroot using `rustc --print sysroot`: '
      --        .. rustc_sysroot
      --      )
      --      local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
      --      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

      --      -- The following is a table/list of lldb commands, which have a syntax
      --      -- similar to shell commands.
      --      --
      --      -- To see which command options are supported, you can run these commands
      --      -- in a shell:
      --      --
      --      --   * lldb --batch -o 'help command script import'
      --      --   * lldb --batch -o 'help command source'
      --      --
      --      -- Commands prefixed with `?` are quiet on success (nothing is written to
      --      -- debugger console if the command succeeds).
      --      --
      --      -- Prefixing a command with `!` enables error checking (if a command
      --      -- prefixed with `!` fails, subsequent commands will not be run).
      --      --
      --      -- NOTE: it is possible to put these commands inside the ~/.lldbinit
      --      -- config file instead, which would enable rust types globally for ALL
      --      -- lldb sessions (i.e. including those run outside of nvim). However,
      --      -- that may lead to conflicts when debugging other languages, as the type
      --      -- formatters are merely regex-matched against type names. Also note that
      --      -- .lldbinit doesn't support the `!` and `?` prefix shorthands.
      --      return {
      --        ([[!command script import '%s']]):format(script_file),
      --        ([[command source '%s']]):format(commands_file),
      --      }
      --    end,
      --    -- ...,
      --  },
      --}

      -- -----------------------
      -- dapui setup
      -- -----------------------
      dapui.setup()

      dap.listeners.after["dap.run"] = function()
        dapui.open()
      end
      dap.listeners.before["dap.exit"] = function()
        dapui.close()
      end

      dap.set_log_level("ERROR")
    end,
  },
  { "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text", opts = {} },
}
