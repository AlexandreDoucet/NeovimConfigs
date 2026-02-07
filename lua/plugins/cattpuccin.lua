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
          -- STRONGER Python colors
          ["@function.python"] = { fg = colors.blue, bold = true },
          ["@function.call.python"] = { fg = colors.blue },
          ["@variable.python"] = { fg = colors.teal },
          ["@field.python"] = { fg = colors.peach, bold = true },
          ["@attribute.python"] = { fg = colors.sapphire }, -- For your pythonAttribute
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  end,
}
