return {
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",

		config = function()
			local telescope = require("telescope")
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
							["<C-j>"] = require("telescope.actions").move_selection_next,
							["<C-k>"] = require("telescope.actions").move_selection_previous,
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

			-- Helper function to set working directory
			local function set_cwd(path)
				if path then
					vim.cmd("cd " .. vim.fn.fnameescape(path))
					print("CWD set to: " .. path)
				end
			end

			-- Define a function to compute the working directory path
			local function get_cwd()
				-- Get the Git root of the current directory where Neovim is launched
				local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

				-- Check if the target file is inside a Git repository
				local target_file = vim.fn.expand("%:p:h")
				local target_git_root = vim.fn.systemlist("git -C " .. target_file .. " rev-parse --show-toplevel")[1]

				-- If the target file has a Git root, return that as the working directory
				if vim.v.shell_error == 0 and target_git_root then
					return target_git_root
				end

				-- If no Git repository is found for the target file, return the file's directory
				if target_file and target_file ~= "" then
					return target_file
				end

				return nil
			end
			--			-- Define a function to compute the working directory path
			--			local function get_cwd()
			--				-- Get the Git root of the current directory
			--				local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			--				if vim.v.shell_error == 0 and git_root then
			--					-- Check if the file path is inside the Git repository
			--					local file_dir = vim.fn.expand("%:p:h")
			--					local is_in_git_repo =
			--						vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")[1]
			--
			--					-- If the file is inside the Git repository, return the Git root
			--					if is_in_git_repo == "true" then
			--						return git_root
			--					end
			--				end
			--
			--				-- If not in a Git repo, return the directory of the file or fallback to current directory
			--				local file_dir = vim.fn.expand("%:p:h")
			--				if file_dir and file_dir ~= "" then
			--					return file_dir
			--				end
			--
			--				return nil
			--			end

			-- Use the function in the autocmd callback
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local cwd = get_cwd()
					if cwd then
						set_cwd(cwd)
					end
				end,
				once = true, -- Set cwd only once per buffer
			})

			-- Keybindings for Telescope fuzzy search with dynamic cwd
			local builtin = require("telescope.builtin")
			-- Keymap: Set cwd to parent directory
			vim.keymap.set("n", "<leader>cdg", function()
				local dir = get_cwd()
				set_cwd(dir)
			end, { noremap = true, silent = true, desc = "Set CWD to git root if available" })

			-- Keymap: Set cwd to parent directory
			vim.keymap.set("n", "<leader>cdp", function()
				local parent_dir = vim.fn.expand("%:p:h:h")
				set_cwd(parent_dir)
			end, { noremap = true, silent = true, desc = "Set CWD to parent directory" })

			-- Keymap: Set cwd to current file's directory
			vim.keymap.set("n", "<leader>cdc", function()
				local file_dir = vim.fn.expand("%:p:h")
				set_cwd(file_dir)
			end, { noremap = true, silent = true, desc = "Set CWD to file's directory" })

			-- Keymap: Fuzzy search in file's directory
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files()
			end, { noremap = true, silent = true, desc = "Find files in file's directory" })

			-- Keymap: Live grep in file's directory
			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep()
			end, { noremap = true, silent = true, desc = "Live grep in file's directory" })

			-- Default keymaps for buffers and help
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
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
