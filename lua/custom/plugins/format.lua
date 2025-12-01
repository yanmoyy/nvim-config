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
	config = function()
		require("conform").setup({
			format_on_save = function(bufnr)
				local disable_filetypes = { cpp = true }
				if
					vim.g.disable_autoformat
					or vim.b[bufnr].disable_autoformat
					or disable_filetypes[vim.bo[bufnr].filetype]
				then
					return nil
				else
					return { timeout_ms = 1000, lsp_format = "fallback" }
				end
			end,
			notify_on_error = false,
			formatters_by_ft = {
				c = { "clang_format" },
				cs = { "csharpier" },
				csproj = { "csharpier" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				typescript = { "prettierd" },
				javascript = { "prettierd" },
				graphql = { "prettierd" },
				yaml = { "prettierd" },
				["yaml.*"] = { "prettierd" },
				css = { "prettierd" },
				html = { "djlint" },
				sh = { "shfmt" },
				env = { "shfmt" },
				-- Conform can also run multiple formatters sequentially
				python = { "isort", "black" },
				sql = { "sql_formatter" },
				go = { "goimports" },
				gomod = { "go_mod_formatter" },
				["*"] = { "injected" }, -- enables injected-lang formatting for all filetypes
			},
			formatters = {
				clang_format = {
					command = "clang-format",
					args = { "--style={BasedOnStyle: WebKit, IndentWidth: 4}" },
					stdin = true,
				},
				djlint = {
					prepend_args = {
						"--line-break-after-multiline-tag",
						"--max-blank-lines=1",
					},
					stdin = true,
				},
				prettierd = {
					prepend_args = function(_, ctx)
						local filetype = vim.bo[ctx.buf].filetype
						if filetype == "markdown" then
							return { "--prose-wrap=always", "--print-width=100" }
						end
						if
							vim.tbl_contains(
								{ "json", "jsonc", "graphql", "yaml", "yaml.github", "yaml.docker-compose" },
								filetype
							)
						then
							return { "--tab-width=2" }
						end
						return { "--tab-width=4" }
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
							sql = {},
						},
					},
				},
			},
		})
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
