return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          rust = { "rustfmt" },
          nix = { "nixpkgs_fmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          jinja = { "djlint" },
        },

        formatters = {
          black = {
            prepend_args = { "--line-length", "120" },
          },
          prettier = {
            prepend_args = {
              "--config",
              vim.fn.expand("~/.config/prettier/.prettierrc"),
            },
          },
        },

        format_on_save = {
          -- these options will be passed to conform.format()
          timeout_ms = 5000,
          lsp_format = "fallback",
        },
      })
    end,
  },
  {
    "lepture/vim-jinja",            -- jinja syntax highlighting plugin
    ft = { "jinja", "htmldjango" }, -- load only for relevant filetypes
  },
}
