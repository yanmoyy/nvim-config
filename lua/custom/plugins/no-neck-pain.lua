return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	config = function()
		vim.keymap.set("n", "<leader>z", "<cmd>NoNeckPain<cr>", { noremap = true, desc = "[Z]en mode" })
		require("no-neck-pain").setup({
			width = 120,
		})
	end,
}
