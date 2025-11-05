-- Create the autocommands module
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "sql", "json", "jsonc", "yaml" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs" },
	callback = function()
		vim.api.nvim_clear_autocmds({
			group = "noice_lsp_progress",
			event = "LspProgress",
			pattern = "*",
		})
	end,
})
