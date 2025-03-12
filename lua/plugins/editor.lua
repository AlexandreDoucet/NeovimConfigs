return {
	{
		"huy-hng/anyline.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true,
		event = "VeryLazy",
	},
	{
		"sphamba/smear-cursor.nvim",

		opts = {
			-- Smear cursor when switching buffers or windows.
			smear_between_buffers = true,

			-- Smear cursor when moving within line or to neighbor lines.
			-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
			smear_between_neighbor_lines = false,

			-- Draw the smear in buffer space instead of screen space when scrolling
			scroll_buffer_space = true,

			-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
			-- Smears will blend better on all backgrounds.
			legacy_computing_symbols_support = false,

			-- Smear cursor in insert mode.
			-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
			smear_insert_mode = true,
		},
	},

	{
		"karb94/neoscroll.nvim",
		opts = {
			mappings = { -- Keys to be mapped to their corresponding default scrolling animation
				"<C-u>",
				"<C-d>",
				"<C-b>",
				"<C-f>",
				"<C-y>",
				"<C-e>",
				"zt",
				"zz",
				"zb",
			},
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
			duration_multiplier = 1.0, -- Global duration multiplier
			easing = "linear", -- Default easing function
			pre_hook = nil, -- Function to run before the scrolling animation starts
			post_hook = function(key)
				-- Center the screen after scrolling
				local win_id = vim.api.nvim_get_current_win()
				local cursor_pos = vim.api.nvim_win_get_cursor(win_id)

				-- Get the current scrolloff value
				local original_scrolloff = vim.api.nvim_win_get_option(win_id, "scrolloff")
				-- Get the total number of lines in the buffer
				local total_lines = vim.api.nvim_buf_line_count(0)

				-- Check if cursor is within the valid scroll region
				if cursor_pos[1] < original_scrolloff and (total_lines - cursor_pos[1] < original_scrolloff) then
					-- Use zz to center the cursor
					--vim.cmd("normal! zz")
				end
			end,
			performance_mode = false, -- Disable "Performance Mode" on all buffers.
			ignored_events = { -- Events ignored while scrolling
				"WinScrolled",
				"CursorMoved",
			},
		},
	},
}
