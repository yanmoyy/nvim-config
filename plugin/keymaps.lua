local set = vim.keymap.set

set("n", "<leader>pv", vim.cmd.Ex)
-- Execute command
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })

-- Clear highlights on search when pressing <Esc> in normal mode
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
-- set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
set("n", "<C-q>", "<C-w><C-q>", { desc = "Close the window" })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })

-- Disable the spacebar key's default behavior in Normal and Visual modes
set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

--------  Kick Start ----------

local opts = { noremap = true, silent = true }

-- delete single character without copying into register
set("n", "x", '"_x', opts)

-- Vertical scroll and center
set("n", "<C-d>", "<C-d>zz", opts)
set("n", "<C-u>", "<C-u>zz", opts)

-- Open file explorer
set("n", "-", "<cmd>Oil<CR>", opts)

-- Diagnostic keymaps
set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)

set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open float Diagnostic" })
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--  See `:help wincmd` for a list of all window commands
-- Split window
-- C-w (q, s, v)

-- Quickfix
set("n", "<C-j>", "<cmd>cnext<CR>")
set("n", "<C-k>", "<cmd>cprev<CR>")

-- Change cwd to file's dir
set("n", "<leader>cc", function()
	local path = vim.fn.expand("%:p:h")
	vim.cmd("cd " .. path)
	print("CWD: " .. vim.fn.getcwd())
end, { desc = "Set CWD to current file and print it" })

-- Remap :W to :w to avoid errors when mistyping
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev Q q")

set("n", "K", function()
	vim.lsp.buf.hover({
		border = "rounded",
	})
end)

-- Golang
set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')
