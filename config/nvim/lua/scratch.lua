local M = {}

local prompt = {
	"//        ヾ( `ー´)シφ__",
	"",
}

-- Function to create a new scratch buffer
function M.open_scratch()
	-- Check if a scratch buffer already exists
	local existing_buf = M.find_scratch_buffer()

	-- If it exists, use it; otherwise, create a new one
	local buf
	if existing_buf then
		buf = existing_buf
	else
		-- Create a new buffer
		buf = vim.api.nvim_create_buf(false, true)

		-- Set buffer options
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
		vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
		vim.api.nvim_set_option_value("filetype", "scratch", { buf = buf })

		-- Use buffer-local variable to mark as scratch
		vim.api.nvim_buf_set_var(buf, "is_scratch", true)

		-- Set name after setting options
		vim.api.nvim_buf_set_name(buf, "[Scratch]")

		-- Optional: Add some initial text
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, prompt)
	end

	-- Open the buffer in a new window
	vim.api.nvim_command("vsplit")
	vim.api.nvim_win_set_buf(0, buf)

	return buf
end

-- Helper function to find an existing scratch buffer
function M.find_scratch_buffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- Check if buffer exists and has our scratch marker
		if vim.api.nvim_buf_is_valid(buf) then
			local is_scratch = pcall(function()
				return vim.api.nvim_buf_get_var(buf, "is_scratch")
			end)
			if is_scratch then
				return buf
			end
		end
	end
	return nil
end

-- Alternative function that opens scratch in a floating window
function M.open_scratch_float()
	-- Check if a scratch buffer already exists
	local existing_buf = M.find_scratch_buffer()

	-- If it exists, use it; otherwise, create a new one
	local buf
	if existing_buf then
		buf = existing_buf
	else
		-- Create a new buffer
		buf = vim.api.nvim_create_buf(false, true)

		-- Set buffer options
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
		vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
		vim.api.nvim_set_option_value("filetype", "scratch", { buf = buf })

		-- Use buffer-local variable to mark as scratch
		vim.api.nvim_buf_set_var(buf, "is_scratch", true)

		-- Set name after setting options
		vim.api.nvim_buf_set_name(buf, "[Scratch]")

		-- Optional: Add some initial text
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, prompt)
	end

	-- Calculate window size and position
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Set window options
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	-- Open the buffer in a floating window
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Set up keymaps to close the floating window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })

	return buf
end

-- Set up auto-commands
local function create_autocmds()
	local augroup = vim.api.nvim_create_augroup("ScratchBufferGroup", { clear = true })

	-- Optional: Auto-resize when window is resized
	vim.api.nvim_create_autocmd("VimResized", {
		group = augroup,
		pattern = "*",
		callback = function()
			local wins = vim.api.nvim_list_wins()
			for _, win in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("%[Scratch%]") then
					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.8)
					local col = math.floor((vim.o.columns - width) / 2)
					local row = math.floor((vim.o.lines - height) / 2)

					vim.api.nvim_win_set_config(win, {
						relative = "editor",
						width = width,
						height = height,
						col = col,
						row = row,
					})
				end
			end
		end,
	})
end

-- Initialize the plugin
function M.setup()
	create_autocmds()
end

return M
