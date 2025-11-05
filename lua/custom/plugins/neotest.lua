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
				"<leader>na",
				function()
					neotest.run.attach()
				end,
				desc = "[N]eotest [A]ttach",
				mode = "n",
			},
			{
				"<leader>nf",
				function()
					neotest.run.run(vim.fn.expand("%"))
				end,
				desc = "[N]eotest [F]ile",
				mode = "n",
			},
			{
				"<leader>nF",
				function()
					neotest.run.run(vim.fn.getcwd())
				end,
				desc = "[N]eotest All [F]ile",
				mode = "n",
			},
			{
				"<leader>nl",
				function()
					neotest.run.run_last()
				end,
				desc = "[N]eotest [L]ast",
				mode = "n",
			},
			{
				"<leader>ns",
				function()
					neotest.summary.toggle()
				end,
				desc = "[N]eotest [S]ummary",
				mode = "n",
			},
			{
				"<leader>nx",
				function()
					neotest.run.stop()
				end,
				desc = "[N]eotest [X]stop",
				mode = "n",
			},
		})
	end,
}
