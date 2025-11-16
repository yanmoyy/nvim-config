return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
		"folke/which-key.nvim",
	},
	config = function()
		local neotest = require("neotest")
		neotest.setup({
			adapters = {
				require("neotest-dotnet"),
			},
		})

		local wk = require("which-key")
		wk.add({
			{
				"<leader>ta",
				function()
					neotest.run.attach()
				end,
				desc = "[T]est [A]ttach",
				mode = "n",
			},
			{
				"<leader>tf",
				function()
					neotest.run.run(vim.fn.expand("%"))
				end,
				desc = "[T]est [F]ile",
				mode = "n",
			},
			{
				"<leader>tF",
				function()
					neotest.run.run(vim.fn.getcwd())
				end,
				desc = "[T]est All [F]ile",
				mode = "n",
			},
			{
				"<leader>tl",
				function()
					neotest.run.run_last()
				end,
				desc = "[T]est [L]ast",
				mode = "n",
			},
			{
				"<leader>ts",
				function()
					neotest.summary.toggle()
				end,
				desc = "[T]est [S]ummary",
				mode = "n",
			},
			{
				"<leader>tx",
				function()
					neotest.run.stop()
				end,
				desc = "[T]est [X]stop",
				mode = "n",
			},
		})
	end,
}
