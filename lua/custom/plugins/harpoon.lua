return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" }, -- No nvim-web-devicons needed
	config = function()
		local harpoon = require("harpoon")
		local wk = require("which-key")

		harpoon:setup()

		-- Define static mappings with vim.keymap.set
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd file" })

		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })

		-- Add dynamic mappings for <leader>1 to <leader>5
		for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
			wk.add({
				{
					string.format("<leader>%d", idx),
					function()
						harpoon:list():select(idx)
					end,
					desc = function()
						local items = harpoon:list().items
						return items[idx] and vim.fn.fnamemodify(items[idx].value, ":t") or ""
					end,
					mode = "n",
					icon = {
						icon = "󰈮",
						color = "azure",
					},
				},
			})
		end
	end,
}
