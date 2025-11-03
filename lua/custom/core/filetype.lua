vim.filetype.add({
	extension = {
		env = "env",
		csproj = "csproj",
	},
	pattern = {
		-- github yaml
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})
