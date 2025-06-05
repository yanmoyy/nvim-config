return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},

	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			markdown = { "prettierd" },
			json = { "prettierd" },
			javascript = { "prettierd" },
			yaml = { "prettierd" },
			css = { "prettierd" },
			html = { "djlint" },
			sh = { "shfmt" },
			-- Conform can also run multiple formatters sequentially
			python = { "isort", "black" },
			sql = { "sql_formatter" },
			go = { "goimports" },
			gomod = { "go_mod_formatter" },
			["*"] = { "injected" }, -- enables injected-lang formatting for all filetypes
		},
		formatters = {
			djlint = {
				prepend_args = {
					"--line-break-after-multiline-tag",
					"--max-blank-lines=1",
				},
				stdin = true,
			},
			prettierd = {
				prepend_args = function(_, ctx)
					if vim.bo[ctx.buf].filetype == "markdown" then
						return { "--prose-wrap=always", "--print-width=80" }
					end
					return { "--tab-width=4", "--use-tabs=false" }
				end,
				stdin = true,
			},
			sql_formatter = {
				command = "sql-formatter",
				args = function()
					local config = {
						language = "postgresql",
						keywordCase = "upper",
						logicalOperatorNewline = "after",
					}
					return {
						"--config",
						vim.json.encode(config),
					}
				end,
				stdin = true, -- add content not file path
			},
			go_mod_formatter = {
				command = "go",
				args = function(_, ctx)
					return { "mod", "edit", "-fmt", ctx.filename }
				end,
				-- Since go mod edit -fmt modifies the file directly, no stdin/stdout
				stdin = false,
				require_cwd = true, -- Ensure it runs in the project directory
			},
			injected = {
				options = {
					lang_to_formatters = {
						go = { "gofumpt" },
					},
				},
			},
		},
	},
}
