return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		local parsers = {
			"json",
			"go",
			"sql",
			"python",
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"graphql",
			"query",
			"vim",
			"vimdoc",
			"c_sharp",
			"xml",
		}

		require("nvim-treesitter").install(parsers)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match

				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				-- check if parser exists and load it
				if not vim.treesitter.language.add(language) then
					return
				end
				-- enables syntax highlighting and other treesitter features
				vim.treesitter.start(buf, language)

				-- enables treesitter based folds
				-- for more info on folds see `:help folds`
				-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				-- vim.wo.foldmethod = 'expr'

				-- enables treesitter based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
		local tsq = vim.treesitter.query

		local bash_format = [[
(program
	(comment) @preceder (#eq? @preceder "# @lang %s")
	.
	(variable_assignment
	  (raw_string) @injection.content
	  (#offset! @injection.content 0 1 0 -1)
	  (#set! injection.language "%s")
    )
  )
]]

		local go_format = [[
(const_spec
	name: (identifier)
 	.
 	(comment) @comment (#eq? @comment "/*%s*/")
 	.
	value: (expression_list
		(raw_string_literal
			(raw_string_literal_content) @injection.content
				(#set! injection.language "%s")
				)))
]]

		local python_dynamic_format = [[
(
  (comment) @preceder (#eq? @preceder "# language=%s")
  .
  (expression_statement
    (assignment
	   right: (string
			  (string_content) @injection.content
			  (#set! injection.language "%s"))
	)
  )
)
]]

		local python_markdown_injection = [[
(
  (comment) @md_marker
  (#lua-match? @md_marker "^# %%%% %[markdown%]$")
  .
  (expression_statement
    (string (string_content) @injection.content)
    (#set! injection.language "markdown")
  )
)
]]
		local function set_injections(base_lang, format_string, target_langs)
			local combined_query = ""
			if base_lang == "python" then
				combined_query = python_markdown_injection
			end
			for _, lang in ipairs(target_langs) do
				combined_query = combined_query .. string.format(format_string, lang, lang)
			end
			tsq.set(base_lang, "injections", combined_query)
		end

		set_injections("bash", bash_format, { "json", "sql" })
		set_injections("go", go_format, { "html", "json", "sql", "graphql" })
		set_injections("python", python_dynamic_format, { "sql" })

		-- set parser to env filetype
		vim.treesitter.language.register("bash", "env")
		vim.treesitter.language.register("xml", "csproj")
	end,
}
