-- Neovim 0.11: use `master`. Plugin `main` is a rewrite for 0.12+ and breaks highlight after :Lazy sync.
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "master",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"gdscript",
			"godot_resource",
			"gdshader",
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
			"xml",
			"odin",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "markdown" },
		},
		indent = {
			enable = true,
			disable = { "gdscript" },
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

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

		vim.treesitter.language.register("bash", "env")
	end,
}
