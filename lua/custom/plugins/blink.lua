return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings

		keymap = {
			preset = "default",
			["<Tab>"] = {
				function()
					local completion = require("llama-cmp.completion")
					if completion.is_visible() and completion.accept() then
						pcall(vim.snippet.stop)
						return true
					end
				end,
				"snippet_forward",
				"fallback",
			},
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		signature = {
			enabled = true,
			trigger = {
				enabled = false,
			},
			window = {
				border = "rounded",
			},
		},

		completion = {
			menu = {
				auto_show = function()
					return vim.g.blink_completion ~= false
				end,
				border = "rounded",
				scrollbar = false,
				-- nvim-cmp style menu
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
				},
			},
			documentation = {
				auto_show = true,
				window = { border = "rounded" },
			},
		},
		sources = {
			default = function()
				if vim.g.blink_completion == false then
					return {}
				end
				return { "lsp", "snippets", "path", "dadbod", "buffer" }
			end,
			per_filetype = {
				sql = function()
					if vim.g.blink_completion == false then
						return {}
					end
					return { "dadbod", "snippets", "buffer" }
				end,
			},
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
				lsp = {
					transform_items = function(ctx, items)
						local after = ctx.line:sub(ctx.cursor[2] + 1)
						if not after:match("^%s*%(") then
							return items
						end
						for _, item in ipairs(items) do
							if item.insertText then
								item.insertText = item.insertText:gsub("%b()", "", 1)
							end
							if item.textEdit and item.textEdit.newText then
								item.textEdit.newText = item.textEdit.newText:gsub("%b()", "", 1)
							end
						end
						return items
					end,
				},
			},
		},
		cmdline = {
			keymap = { preset = "inherit" },
			completion = {
				ghost_text = { enabled = true }, -- for noice
				menu = { auto_show = true },
			},
		},
		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
	keys = {
		{
			"<leader>tc",
			function()
				vim.g.blink_completion = vim.g.blink_completion == false
				if vim.g.blink_completion == false then
					pcall(require("blink.cmp").hide)
					vim.notify("Completion off", vim.log.levels.INFO)
				else
					vim.notify("Completion on", vim.log.levels.INFO)
				end
			end,
			desc = "[T]oggle [C]ompletion",
		},
	},
}
