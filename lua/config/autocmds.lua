---- Do some magic with autocmd
-- Remove trailing space
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "always",
			offset_x = 30, -- Move the window 4 characters to the right
		})
	end,
})

--vim.api.nvim_create_autocmd("CursorHold", {
--	pattern = "*",
--	callback = function()
--		require("lspsaga.hover"):render_hover_doc()
--	end,
--})
