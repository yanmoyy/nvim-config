return {
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				go = { "golangcilint" },
				dockerfile = { "hadolint" },
				html = { "djlint" },
				["yaml.github"] = { "actionlint" },
			}

			local goci = lint.linters.golangcilint

			goci.args = vim.list_extend(goci.args, {
				"--default=standard",
			})

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "[L]inting Trigger" })
		end,
	},
}
