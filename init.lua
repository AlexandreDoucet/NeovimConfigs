-- put this at the very top of init.lua, before any plugin loads
local orig_start_client = vim.lsp.start_client
vim.lsp.start_client = function(config)
  if config.name == "rust_analyzer" then
    print("\n⚠️ rust-analyzer LSP client being started by:")
    print(debug.traceback("", 2))
    print("-------------------------------------------------\n")
  end
  return orig_start_client(config)
end


require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

if vim.o.filetype == "lazy" then
  vim.cmd.close()
end
