vim.api.nvim_create_user_command("CleanDOS", "silent! %s/\r//g", { nargs = 0, desc = "Clean newline characters" })
