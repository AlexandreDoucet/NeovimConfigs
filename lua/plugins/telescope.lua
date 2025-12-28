return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local builtin = require("telescope.builtin")

      -- Setup Telescope
      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = "→ ",
          layout_config = {
            horizontal = { width = 0.9, preview_cutoff = 120 },
            vertical = { width = 0.8, height = 0.9 },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("noice")

      -- Helper to set working directory
      local function set_cwd(path)
        if path then
          vim.cmd("cd " .. vim.fn.fnameescape(path))
          print("CWD set to: " .. path)
        end
      end

      -- Compute working directory: Git root or file's directory
      local function get_cwd()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        local file_dir = vim.fn.expand("%:p:h")
        local target_git_root = vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --show-toplevel")[1]

        if vim.v.shell_error == 0 and target_git_root and target_git_root ~= "" then
          return target_git_root
        end
        return file_dir ~= "" and file_dir or nil
      end

      -- Set cwd once per buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          local cwd = get_cwd()
          if cwd then set_cwd(cwd) end
        end,
        once = true,
      })

      -- Helper to attach Enter mapping to jump to selection
      local function attach_jump_mappings(prompt_bufnr)
        local function jump_to_selection()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection.path then
            vim.cmd("edit " .. selection.path)
            if selection.lnum and selection.col then
              vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
            end
          end
        end

        -- Map Enter in insert and normal mode
        local map = function(mode, key)
          vim.keymap.set(mode, key, jump_to_selection, { buffer = prompt_bufnr, noremap = true, silent = true })
        end

        map("i", "<CR>")
        map("n", "<CR>")
      end

      -- Telescope keymaps
      vim.keymap.set("n", "<leader>cdg", function()
        set_cwd(get_cwd())
      end, { noremap = true, silent = true, desc = "Set CWD to Git root" })

      vim.keymap.set("n", "<leader>cdp", function()
        set_cwd(vim.fn.expand("%:p:h:h"))
      end, { noremap = true, silent = true, desc = "Set CWD to parent directory" })

      vim.keymap.set("n", "<leader>cdc", function()
        set_cwd(vim.fn.expand("%:p:h"))
      end, { noremap = true, silent = true, desc = "Set CWD to file directory" })

      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({
          attach_mappings = function(prompt_bufnr, map)
            attach_jump_mappings(prompt_bufnr)
            return true
          end,
        })
      end, { noremap = true, silent = true, desc = "Find files and jump to selection" })

      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({
          attach_mappings = function(prompt_bufnr, map)
            attach_jump_mappings(prompt_bufnr)
            return true
          end,
        })
      end, { noremap = true, silent = true, desc = "Live grep and jump to selection" })

      vim.keymap.set("n", "<leader>fb", function()
        builtin.buffers({
          attach_mappings = function(prompt_bufnr, map)
            attach_jump_mappings(prompt_bufnr)
            return true
          end,
        })
      end, { noremap = true, silent = true, desc = "List buffers and jump" })

      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
