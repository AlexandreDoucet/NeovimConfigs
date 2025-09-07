return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},

		config = function()
			-- Set up render-markdown plugin
			require("render-markdown").setup({
				bullet = {
					enabled = true,
					icons = { "●", "○", "◆", "◇" },
					ordered_icons = function(level, index, value)
						value = vim.trim(value)
						local value_index = tonumber(value:sub(1, #value - 1))
						return string.format("%d.", value_index > 1 and value_index or index)
					end,
					left_pad = 0,
					right_pad = 0,
					highlight = "RenderMarkdownBullet",
				},
				checkbox = {
					enabled = true,
					position = "inline",
					unchecked = {
						icon = "󰄱 ",
						highlight = "RenderMarkdownUnchecked",
					},
					checked = {
						icon = "󰱒 ",
						highlight = "RenderMarkdownChecked",
					},
					custom = {
						todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
					},
				},
			})

			-- custom function to toggle checkbox state
			local function insert_checkbox()
				local line = vim.api.nvim_get_current_line() -- get the current line

				-- check if the line already contains a checkbox
				if line:match("^%s*[%-]%s%[.*%]") then
					-- toggle the checkbox state between [ ] and [x]
					local new_line = line
					if line:match("^%s*[%-]%s%[%s*]") then
						new_line = line:gsub("%[%s*%]", "[x]") -- change unchecked to checked
					elseif line:match("%[.*]") then
						new_line = line:gsub("%[%s*x%s*%]", "[ ]") -- change checked to unchecked
					end
					-- set the modified line back
					vim.api.nvim_set_current_line(new_line)
				else
					-- if no checkbox exists, insert an unchecked checkbox
					vim.api.nvim_set_current_line("- [ ] " .. line)
				end
			end

			-- create a keymap to call the function (using the newer api `vim.keymap.set`)
			vim.keymap.set("n", "<leader>cb", insert_checkbox, { noremap = true, silent = true })
		end,
	},
}
