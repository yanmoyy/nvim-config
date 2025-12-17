return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()
		require("mini.pairs").setup()

		local hipatterns = require("mini.hipatterns")

		vim.api.nvim_set_hl(0, "MiniHipatternsJupyterCell", {
			fg = "#cdcdcd",
			bg = "#717190",
			bold = true,
		})

		hipatterns.setup({
			highlighters = {
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "python" },
			callback = function()
				require("mini.hipatterns").enable(vim.api.nvim_get_current_buf(), {
					highlighters = {
						jupyter_cell = {
							pattern = "^# %%%%.*$",
							group = "MiniHipatternsJupyterCell",
						},
					},
				})
			end,
		})
	end,
}
