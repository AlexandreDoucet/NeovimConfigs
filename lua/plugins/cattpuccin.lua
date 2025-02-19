return {
	--colorscheme
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,

	config = function()
		vim.cmd.colorscheme("catppuccin")
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	end,

	custom_highlights = function(colors)
		return {
			-- Comment = { fg = colors.flamingo },
			-- TabLineSel = { bg = colors.pink },
			-- CmpBorder = { fg = colors.surface2 },
			-- Pmenu = { bg = colors.none },
			BlinkCmpMenu = { bg = colors.surface0 },
			BlinkCmpDoc = { bg = colors.surface1 },
		}
	end,
}
