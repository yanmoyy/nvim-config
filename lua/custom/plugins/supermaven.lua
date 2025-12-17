return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			ignore_filetypes = { "env" },
			ignore_filetypes = { "dbout" },
		})
		local api = require("supermaven-nvim.api")
		-- api.toggle()
		vim.keymap.set("n", "<leader>mt", "<cmd>SupermavenToggle<cr>", { desc = "Super[M]aven [T]oggle" })
	end,
}
