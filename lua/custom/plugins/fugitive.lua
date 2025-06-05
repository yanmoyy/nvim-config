return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
			desc = "[G]it [S]tatus",
		})
		vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<CR>", {
			desc = "[G]it [A]dd .",
		})
		vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", {
			desc = "[G]it [C]ommit ",
		})
		vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", {
			desc = "[G]it [P]ush",
		})
	end,
}
