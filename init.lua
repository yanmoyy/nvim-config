-- Set map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("custom.core.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@type table
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = true,
	},
})
