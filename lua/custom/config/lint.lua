local lint = require("lint")

lint.linters_by_ft = {
	go = { "golangcilint" },
	dockerfile = { "hadolint" },
	html = { "djlint" },
	["yaml.github"] = { "actionlint" },
}

local goci = lint.linters.golangcilint

local additional_args = {
	"--enable=gosec",
}

goci.args = vim.list_extend(goci.args, additional_args)

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		-- Only run the linter in buffers that you can modify in order to
		-- avoid superfluous noise, notably within the handy LSP pop-ups that
		-- describe the hovered symbol using Markdown.
		if vim.opt_local.modifiable:get() then
			lint.try_lint()
		end
	end,
})
