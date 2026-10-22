return {
	"danymat/neogen",
	config = function()
		local neogen = require("neogen")
		neogen.setup({
			enabled = true,
		})
		vim.keymap.set("n", "<Leader>do", "<CMD>Neogen [D]ocument<CR>")
	end,
	-- Uncomment next line if you want to follow only stable versions
	-- version = "*"
}
