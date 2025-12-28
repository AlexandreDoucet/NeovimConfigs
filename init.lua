require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

if vim.o.filetype == "lazy" then
  vim.cmd.close()
end
