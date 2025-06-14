vim.filetype.add({
	extension = {
		env = "env",
	},
	pattern = {
		-- github yaml
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
})
