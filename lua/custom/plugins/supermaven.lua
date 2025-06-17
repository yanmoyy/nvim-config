return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			ignore_filetypes = { "env" },
		})
		vim.keymap.set("n", "<leader>mt", "<cmd>SupermavenToggle<cr>", { desc = "Super[M]aven [T]oggle" })
	end,
}
