return {
	"glepnir/lspsaga.nvim",
	enabled = true,
	config = function()
		require("lspsaga").setup({
			ui = {
				border = "rounded",
			},
			hover = {
				max_width = 80, -- Set maximum width of the hover window
				max_height = 10, -- Set maximum height of the hover window
				side = "below", -- Always display the hover window below
			},
			diagnostic = {
				show_source = true, -- Show the source of the diagnostic
				show_header = true, -- Include header in diagnostics
				border = "rounded", -- Match border style with hover
				max_width = 60, -- Limit width for diagnostic popup
				max_height = 10, -- Limit height for diagnostic popup
				update_in_insert = false, -- Avoid popups in insert mode
				virtual_text = true, -- Display inline diagnostics
			},
		})
	end,
	event = "BufRead",
}
