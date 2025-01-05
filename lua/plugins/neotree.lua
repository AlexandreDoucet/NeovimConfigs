return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},

	close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab

	opts = {
		window = {
			position = "left", -- Set the Neo-tree window to open on the left

			mappings = {
				["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
			},
		},

		filesystem = {
			filtered_items = {
				visible = false, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = true, -- only works on Windows for hidden files/directories
				hide_by_name = {
					--"node_modules"
					".git",
				},
				hide_by_pattern = { -- uses glob style patterns
					--"*.meta",
					--"*/src/*/tsconfig.json",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					--".gitignored",
				},
				always_show_by_pattern = { -- uses glob style patterns
					".env*",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					--".DS_Store",
					--"thumbs.db"
				},
				never_show_by_pattern = { -- uses glob style patterns
					--".null-ls_*",
				},
			},
		},
	},

	config = function(_, opts)
		-- Check if Neo-tree is focused
		local function is_neotree_focused()
			return vim.bo.filetype == "neo-tree"
		end

		-- Key mappings for Neo-tree actions
		vim.keymap.set("n", "<leader>n", function()
			if is_neotree_focused() then
				-- Close Neo-tree if focused
				vim.cmd("Neotree close")
			else
				-- Open or focus Neo-tree on the left and reveal
				vim.cmd("Neotree focus left reveal")
			end
		end)

		-- Close Neo-tree with <leader>m
		vim.keymap.set("n", "<leader>m", ":Neotree close<CR>")

		-- Show Git status in Neo-tree float window
		vim.keymap.set("n", "<leader>gs", ":Neotree git_status float<CR>")

		-- Setup Neo-tree with the specified options
		require("neo-tree").setup(opts)
	end,
}
