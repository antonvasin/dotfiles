local M = {}

local call_path = "v:lua.require'moveline'."

local restore_dot_repetition = function(count)
	count = count or ""
	local callback = vim.go.operatorfunc
	vim.go.operatorfunc = ""
	vim.cmd("silent! normal " .. count .. "g@l")
	vim.go.operatorfunc = callback
end

M.move_up = function()
	local count = vim.v.count1
	vim.cmd("silent! move --" .. count)
	vim.cmd.normal("==")
	restore_dot_repetition(count)
end

M.move_down = function()
	local count = vim.v.count1
	vim.cmd("silent! move +" .. count)
	vim.cmd.normal("==")
	restore_dot_repetition(count)
end

M.move_selection_up = function()
	local count = vim.v.count1
	vim.cmd("silent! '<,'>move '<--" .. count)
	vim.cmd.normal("gv=")
	restore_dot_repetition(count)
end

M.move_selection_down = function()
	local count = vim.v.count1
	vim.cmd("silent! '<,'>move '>+" .. count)
	vim.cmd.normal("gv=")
	restore_dot_repetition(count)
end

M.move = function(dir)
	vim.go.operatorfunc = call_path .. "move_" .. dir
	return "g@l"
end

M.move_selection = function(dir)
	vim.go.operatorfunc = call_path .. "move_selection_" .. dir
	return "g@l"
end

return M
