return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        treesitter = true,
      },
      custom_highlights = function(colors)
        return {
          BlinkCmpMenu = { bg = colors.surface0 },
          BlinkCmpDoc = { bg = colors.surface1 },
          -- Treesitter Python polish
          ["@function.python"] = { fg = colors.sapphire },
          ["@variable.python"] = { fg = colors.rosewater },
          ["@field.python"] = { fg = colors.peach },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  end,
}
