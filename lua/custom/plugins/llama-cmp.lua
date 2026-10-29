return {
	"maxpaulus43/llama-cmp.nvim",
	opts = {
		model = "qwen2.5-coder:0.5b-base",
		preset = "qwen",

		auto_trigger = true,
		debounce_ms = 100,

		context = {
			max_prefix_lines = 50, -- Lines before cursor
			max_suffix_lines = 20, -- Lines after cursor
			max_line_length = 500, -- Truncate long lines
			lsp = {
				enabled = false, -- Include LSP context
			},
		},
		generation = {
			max_tokens = 64,
			temperature = 0.1,
			stop = { "\n", "<|endoftext|>" },
		},
	},
	config = function(_, opts)
		local llama = require("llama-cmp")
		llama.setup(opts)

		local completion = require("llama-cmp.completion")
		local ghost = require("llama-cmp.ghost")
		local namespace = ghost.get_namespace()
		local skip_trigger = false

		local clear = ghost.clear
		function ghost.clear()
			local extra = ghost.get_position()
			clear()
			local bufnr = vim.api.nvim_get_current_buf()
			pcall(vim.api.nvim_buf_clear_namespace, bufnr, namespace, 0, -1)
			if extra and extra.bufnr and extra.bufnr ~= bufnr then
				pcall(vim.api.nvim_buf_clear_namespace, extra.bufnr, namespace, 0, -1)
			end
		end

		-- The model often writes the missing piece and then copies the text
		-- already after the cursor. Drop that copied tail. `6` followed by
		-- the existing `: Character = ...` is shown as `6`.
		local function trim_echoed_tail(text, after)
			if after == "" then
				return text
			end
			local limit = math.min(#text, #after)
			for len = limit, 1, -1 do
				if text:sub(-len) == after:sub(1, len) then
					if len == #after or len >= 2 then
						return text:sub(1, #text - len)
					end
					return text
				end
			end
			return text
		end

		-- A suggestion that is only indentation is drawn after the cursor,
		-- which looks like the cursor jumped.
		local show = ghost.show
		function ghost.show(text, bufnr, cursor)
			local current = vim.api.nvim_win_get_cursor(0)
			if not text or current[1] ~= cursor[1] or current[2] ~= cursor[2] then
				ghost.clear()
				return
			end
			text = text:gsub("^\t+", ""):gsub("^  +", "")
			local line = vim.api.nvim_buf_get_lines(bufnr, cursor[1] - 1, cursor[1], false)[1] or ""
			text = trim_echoed_tail(text, line:sub(cursor[2] + 1))
			if text == "" then
				ghost.clear()
				return
			end
			show(text, bufnr, cursor)
		end

		-- Drop the gray text before the key is inserted. If it is still
		-- on the cursor, the new character pushes the cursor forward.
		vim.api.nvim_create_autocmd("InsertCharPre", {
			group = vim.api.nvim_create_augroup("llama-cmp-insert", { clear = true }),
			callback = function()
				ghost.clear()
			end,
		})

		local on_text_changed = completion.on_text_changed
		function completion.on_text_changed()
			if skip_trigger then
				ghost.clear()
				return
			end
			return on_text_changed()
		end

		-- Tab inserts the gray text, then the gray copy has to be gone.
		function completion.accept()
			local text = ghost.get_text()
			if not completion.is_visible() or not text or text == "" then
				ghost.clear()
				return false
			end
			local line = vim.split(text, "\n", { plain = true })[1]
			if not line or line == "" then
				completion.dismiss()
				return false
			end
			skip_trigger = true
			completion.dismiss()
			vim.schedule(function()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local row, col = cursor[1], cursor[2]
				local current = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
				local updated = current:sub(1, col) .. line .. current:sub(col + 1)
				vim.api.nvim_buf_set_lines(0, row - 1, row, false, { updated })
				vim.api.nvim_win_set_cursor(0, { row, col + #line })
				ghost.clear()
				skip_trigger = false
			end)
			return true
		end

		vim.keymap.set("n", "<leader>lt", "<cmd>LlamaCmp toggle<cr>", { desc = "[L]lama [T]oggle" })
	end,
}
