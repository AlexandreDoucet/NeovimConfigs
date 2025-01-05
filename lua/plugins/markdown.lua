return {
	{
		--		"AlexandreDoucet/render-markdown.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		opts = {}, -- Remove if not needed

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

			-- Custom function to toggle checkbox state
			local function insert_checkbox()
				local line = vim.api.nvim_get_current_line() -- Get the current line

				-- Check if the line already contains a checkbox
				if line:match("^%s*[%-]%s%[.*%]") then
					print("hit")
					-- Toggle the checkbox state between [ ] and [x]
					local new_line = line
					if line:match("^%s*[%-]%s%[%s*]") then
						new_line = line:gsub("%[%s*%]", "[x]") -- Change unchecked to checked
					elseif line:match("%[.*]") then
						new_line = line:gsub("%[%s*x%s*%]", "[ ]") -- Change checked to unchecked
					end
					-- Set the modified line back
					vim.api.nvim_set_current_line(new_line)
				else
					-- If no checkbox exists, insert an unchecked checkbox
					vim.api.nvim_set_current_line("- [ ] " .. line)
				end
			end

			-- Create a keymap to call the function (using the newer API `vim.keymap.set`)
			vim.keymap.set("n", "<leader>cb", insert_checkbox, { noremap = true, silent = true })
		end,
	},
}
