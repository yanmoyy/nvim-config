local opt = vim.opt

----- Interesting Options -----

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----

opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim. (default: '')
opt.number = true -- Make line numbers defualt (default: false)
opt.relativenumber = true -- Set relative numbered lines (default: false)
opt.cursorline = true
opt.cursorlineopt = "number"

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.shada = { "'10", "<0", "s10", "h" }

-- Disable swapfile, backup, undodir, undofile
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.breakindent = true -- Enable break indent

opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time

vim.cmd([[autocmd FileType * set formatoptions-=o]]) -- Don't have `o` add a comment
opt.wrap = true
opt.linebreak = true

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

opt.more = false -- Disable --More-- prompt
opt.foldmethod = "manual"
opt.colorcolumn = "80"

opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true

opt.isfname:append("@-@") -- Allow @ in filename

vim.o.list = false
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.c_syntax_for_h = 1 -- Enable c syntax for h files
