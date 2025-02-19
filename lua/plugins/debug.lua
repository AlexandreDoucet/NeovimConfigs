return {
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
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
      { "<leader>du", function() require("dapui").toggle() end,                                             desc = "Toggle DAP UI" }, -- Keybinding to toggle UI
    },

		config = function()
			-- Highlight setup for stopped lines
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- Define signs for DAP
			local dap_signs = {
				Breakpoint = { "", "DiagnosticError" },
				Stopped = { "", "DiagnosticWarn" },
			}
			for name, sign in pairs(dap_signs) do
				vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2], linehl = "", numhl = "" })
			end

			-- Load VS Code launch.json support
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end

			-- Configure adapters and languages
			local dap = require("dap")
			dap.set_log_level("ERROR") -- Set the log level to TRACE for detailed logs
			dap.adapters.python = {
				type = "executable",
				command = "/run/current-system/sw/bin/python3",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "/run/current-system/sw/bin/python3"
					end,
				},
			}

			-- Configure the Rust adapter (codelldb)
			dap.adapters.lldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.exepath("codelldb"),
					args = { "--port", "${port}" },
				},
			}

			-- Rust debugging configurations
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						-- Get the default executable name from cargo build
						local default_executable = vim.fn.getcwd()
							.. "/target/debug/"
							.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						return vim.fn.input("Path to executable: ", default_executable, "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {}, -- Add any program arguments here
					runInTerminal = false,
				},
			}

			-- Set up dapui (ensure it opens when debugging)
			local dapui = require("dapui")
			dapui.setup() -- Initialize dapui

			dap.listeners.after["dap.run"] = function()
				dapui.open()
			end
			dap.listeners.before["dap.exit"] = function()
				dapui.close()
			end
		end,
	},
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
}
