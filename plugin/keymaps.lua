local set = vim.keymap.set 
-- Execute command
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Clear highlights on search when pressing <Esc> in normal mode
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- TIP: Disable arrow keys in normal mode
set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic' })
-- set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open float Diagnostic' })
-- set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  See `:help wincmd` for a list of all window commands
-- Split window
-- C-w (q, s, v)
set('n', '<C-r>', '<Cmd>mode<CR>')