vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- change tab settings to 2 spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Editor parameters
vim.opt.ttimeoutlen = 10 -- helps with registering leader key and escape faster (ToTest)
vim.opt.relativenumber = true -- Uses relative numbers for easier jumping
vim.opt.cursorline = true -- Display the line number the cursor is one
vim.opt.number = true -- Show the current line number the cursor is on instead of 0.
vim.opt.scrolloff = 10 -- Keeps cursor above N lines of the enf of the screen if not at the end of the file
vim.opt.undofile = true --preserve undo after close (ToTest)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.o.updatetime = 300 -- Set delay to 300ms
vim.o.signcolumn = "yes" -- Always display the sign column
vim.opt.scrolloff = 10

-- folding
vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "indent"

vim.opt.foldnestmax = 1
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

--local function close_all_folds()
--	vim.api.nvim_exec2("%foldc!", { output = false })
--end
--local function open_all_folds()
--	vim.api.nvim_exec2("%foldo!", { output = false })
--end

--vim.keymap.set("n", "<leader>zs", close_all_folds, { desc = "[s]hut all folds" })
--vim.keymap.set("n", "<leader>zo", open_all_folds, { desc = "[o]pen all folds" })

vim.g.blink_cmp_insert_args = true

vim.filetype.add({
	extension = {
		jinja = "jinja",
		j2 = "jinja",
	},
})
