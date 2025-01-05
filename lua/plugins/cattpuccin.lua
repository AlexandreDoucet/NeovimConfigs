return{
  --colorscheme
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000,
  lazy = false,

  config = function()
    vim.cmd.colorscheme "catppuccin"
    vim.api.nvim_set_hl(0,"NormalFloat",{bg = "none"})
    vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
  end
}
