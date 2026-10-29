-- Create the autocommands module
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gdscript",
	callback = function()
		vim.schedule(function()
			if vim.bo.filetype ~= "gdscript" then
				return
			end
			local lines = vim.api.nvim_buf_get_lines(0, 0, 80, false)
			local uses_tabs = false
			for _, line in ipairs(lines) do
				if line:match("^\t") then
					uses_tabs = true
					break
				end
				if line:match("^ ") then
					break
				end
			end
			vim.bo.expandtab = not uses_tabs
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
			vim.bo.softtabstop = 4
			vim.bo.smartindent = false
			vim.bo.cindent = false
			vim.bo.indentexpr = "v:lua.require('custom.gdscript_indent').indent()"
		end)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "sql", "json", "jsonc", "yaml", "cmake" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		-- no wrap
		vim.opt_local.wrap = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.keymap.set("n", "<leader>jm", function()
			local lines = {
				"# %% [markdown]",
				'"""',
				"",
				'"""',
			}
			vim.api.nvim_put(lines, "l", true, true)
			-- Move cursor inside the triple quotes, ready to type
			vim.cmd("normal! k")
			vim.cmd("startinsert")
		end, { desc = "[J]upyter [M]arkdown" })

		vim.keymap.set("n", "<leader>ja", "o# %%<CR>", { desc = "[J]upyter [A]ppend" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
		vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')
		vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
		vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')
	end,
})
