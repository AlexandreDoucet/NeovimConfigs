return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support for multiple languages",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
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
      --{ "<leader>du", function() require("dapui").toggle() end,                                             desc = "Toggle DAP UI" },
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
      -- dapui setup
      -- -----------------------
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dap.set_log_level("ERROR")
    end,
  },
  --{ "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  --{ "theHamsta/nvim-dap-virtual-text", opts = {} },
}
