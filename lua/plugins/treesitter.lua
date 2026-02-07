return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "rust", "ron", "python", "lua", "vim", "vimdoc", "bash", "json", "yaml", "markdown" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    fold = { enable = true },
  },
}
