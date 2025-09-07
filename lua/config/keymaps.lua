vim.keymap.set("n", "<leader>pv", ":silent Ex<CR>")
--Save file on ctrl - s
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.api.nvim_set_keymap("n", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

--Hover window
--vim.api.nvim_set_keymap("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- auto add closing {, [, (, ', ", <
--map("i", "{<cr>", "{<cr>}<ESC>kA<CR>", {})
--Closing_pairs = { "}", ")", "]", '"', "'", ">" }
--Opening_pairs = { "{", "(", "[", '"', "'", "<" }
--for key, chr in pairs(Opening_pairs) do
--	map("i", chr, chr .. Closing_pairs[key] .. "<esc>i", {})
--end

vim.api.nvim_set_keymap("n", "<S-Up>", [[:lua vim.fn["feedkeys"]('yykPjjddkk')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Down>", [[:lua vim.fn["feedkeys"]('yyddp')<CR>]], { noremap = true, silent = true })

--vim.keymap.set("n", "<C-d>", "<C-d>zz")
--vim.keymap.set("n", "<C-u>", "<C-u>zz")
--vim.keymap.set("n", "<C-f>", "<C-f>zz")
--vim.keymap.set("n", "<C-b>", "<C-b>zz")
--
-- Noice notifcations
vim.api.nvim_set_keymap("n", "<leader>dn", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

