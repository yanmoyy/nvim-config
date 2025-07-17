local wk = require("which-key")
local harpoon = require("harpoon")
harpoon:setup()

local mapping_opts = { mode = "n", icon = { icon = "󰈮", color = "azure" } }

-- Change these to leader-based mappings instead of Alt/Meta
wk.add({
	{
		"<leader>ha",
		function()
			harpoon:list():add()
		end,
		desc = "[H]arpoon [A]dd file",
		icon = mapping_opts.icon,
		mode = mapping_opts.mode,
	},
	{
		"<leader>hl",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "[H]arpoon [L]ist",
		icon = mapping_opts.icon,
		mode = mapping_opts.mode,
	},
})

-- Keep the number shortcuts but add descriptions
for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
	wk.add({
		string.format("<leader>%d", idx),
		function()
			harpoon:list():select(idx)
		end,
		desc = string.format("Harpoon file %d", idx),
		icon = mapping_opts.icon,
		mode = mapping_opts.mode,
	})
end
