local M = {}

function M.indent()
	local previous_row = vim.v.lnum - 1
	if previous_row < 1 then
		return 0
	end
	local previous = vim.fn.getline(previous_row)
	local previous_indent = vim.fn.indent(previous_row)
	local width = vim.fn.shiftwidth()
	if previous:match(":%s*$") or previous:match(":%s*#") then
		return previous_indent + width
	end
	return previous_indent
end

return M
