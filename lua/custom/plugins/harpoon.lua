return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		---
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Change these to leader-based mappings instead of Alt/Meta
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd file" })

		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })

		-- Keep the number shortcuts but add descriptions
		for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
			vim.keymap.set("n", string.format("<leader>%d", idx), function()
				harpoon:list():select(idx)
			end, { desc = string.format("Harpoon file %d", idx) })
		end
	end,
}
