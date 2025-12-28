-- If this plugin throws an error, then run this command with the correct username and group to fix it. It iw probably caused bu the root user creating the repository first.
--sudo chown adoucet:users ~/.local/share/nvim/lazy/nvim-treesitter/parser
--
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ':TSUpdate',
}
