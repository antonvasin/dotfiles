local M = {}
local Job = require("plenary.job")

local default_system_prompt =
	"You're a programming assistant. You're being send the code with comments comments containing description of the task. Replace the code that you're sent, only following the comments. Do not talk at all. Only output valid code. Think step by step. Nevery provide any backticks that surround the code. Any comment that is asking you for something should be removed after you satisfy them. Other comments should be left alone."

M.providers = {
	anthropic = {
		url = "https://api.anthropic.com/v1/messages",
		model = "claude-3-5-sonnet-20240620",
		api_key_name = "ANTHROPIC_API_KEY",
		handle_spec_data = function(data_stream, event_state)
			if event_state == "content_block_delta" then
				local json = vim.json.decode(data_stream)
				if json.delta and json.delta.text then
					M.write_string_at_cursor(json.delta.text)
				end
			end
		end,
	},
	openai = {
		url = "https://api.openai.com/v1/chat/completions",
		model = "gpt-4o",
		-- model = "o1-preview",
		api_key_name = "OPENAI_API_KEY",
		handle_spec_data = function(data_stream)
			if data_stream:match('"delta":') then
				local json = vim.json.decode(data_stream)
				if json.choices and json.choices[1] and json.choices[1].delta then
					local content = json.choices[1].delta.content
					if content then
						M.write_string_at_cursor(content)
					end
				end
			end
		end,
	},
}

function M.providers.anthropic.get_args(opts, prompt, system_prompt)
	local api_key = os.getenv(M.providers.anthropic.api_key_name)
	local data = {
		model = M.providers.anthropic.model,
		messages = {
			{ role = "assistant", content = system_prompt },
			{ role = "user", content = prompt },
		},
		stream = true,
		max_tokens = 4096,
	}

	local args = { "-N", "-v" }

	if api_key then
		table.insert(args, "-H")
		table.insert(args, "x-api-key: " .. api_key)
		table.insert(args, "-H")
		table.insert(args, "anthropic-version: 2023-06-01")
		table.insert(args, "-H")
		table.insert(args, "Content-Type: application/json")
		table.insert(args, "-d")
		table.insert(args, vim.json.encode(data))
		table.insert(args, M.providers.anthropic.url)
	else
		print("ANTHROPIC_API_KEY not found")
	end
	return args
end

function M.providers.openai.get_args(opts, prompt, system_prompt)
	local api_key = os.getenv(M.providers.openai.api_key_name)
	local data = {
		messages = { { role = "system", content = system_prompt }, { role = "user", content = prompt } },
		model = M.providers.openai.model,
		temperature = opts.temperature or 0.7,
		stream = true,
	}
	local args = { "-N", "-X", "POST", "-H", "Content-Type: application/json", "-d", vim.json.encode(data) }
	if api_key then
		table.insert(args, "-H")
		table.insert(args, "Authorization: Bearer " .. api_key)
	else
		print("No OPENAI_API_KEY found")
	end
	table.insert(args, M.providers.openai.url)
	return args
end

function M.get_lines_until_cursor()
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_window = vim.api.nvim_get_current_win()
	local cursor_position = vim.api.nvim_win_get_cursor(current_window)
	local row = cursor_position[1]

	local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, row, true)

	return table.concat(lines, "\n")
end

function M.get_visual_selection()
	local _, srow, scol = unpack(vim.fn.getpos("v"))
	local _, erow, ecol = unpack(vim.fn.getpos("."))

	if vim.fn.mode() == "V" then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	if vim.fn.mode() == "v" then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end

	if vim.fn.mode() == "\22" then
		local lines = {}
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		for i = srow, erow do
			table.insert(
				lines,
				vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
			)
		end
		return lines
	end
end

function M.write_string_at_cursor(str)
	vim.schedule(function()
		local current_window = vim.api.nvim_get_current_win()
		local cursor_position = vim.api.nvim_win_get_cursor(current_window)
		local row, col = cursor_position[1], cursor_position[2]

		local lines = vim.split(str, "\n")

		vim.cmd("undojoin")
		vim.api.nvim_put(lines, "c", true, true)

		local num_lines = #lines
		local last_line_length = #lines[num_lines]
		vim.api.nvim_win_set_cursor(current_window, { row + num_lines - 1, col + last_line_length })
	end)
end

local group = vim.api.nvim_create_augroup("LLM_AutoGroup", { clear = true })
local active_job = nil

function M.invoke_llm_and_stream_into_editor(opts)
	local provider = opts.provider or "anthropic"
	if not M.providers[provider] then
		print("Can't find config for provider.")
		return
	end
	vim.api.nvim_clear_autocmds({ group = group })

	local replace = opts.replace or true
	local visual_lines = M.get_visual_selection()
	local prompt = ""

	if visual_lines then
		prompt = table.concat(visual_lines, "\n")
		if replace then
			vim.api.nvim_command("normal! d")
			vim.api.nvim_command("normal! k")
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
		end
	else
		prompt = M.get_lines_until_cursor()
	end

	local system_prompt = opts.system_prompt or default_system_prompt
	local make_curl_args_fn = M.providers[provider].get_args
	local args = make_curl_args_fn(opts, prompt, system_prompt)
	local handle_data_fn = M.providers[provider].handle_spec_data
	local curr_event_state = nil

	local function parse_and_call(line)
		local event = line:match("^event: (.+)$")
		if event then
			curr_event_state = event
			return
		end
		local data_match = line:match("^data: (.+)$")
		if data_match then
			handle_data_fn(data_match, curr_event_state)
		end
	end

	if active_job then
		active_job:shutdown()
		active_job = nil
	end

	active_job = Job:new({
		command = "curl",
		args = args,
		on_stdout = function(_, out)
			parse_and_call(out)
		end,
		on_stderr = function(_, err)
			print("LLM Error: ", err)
		end,
		on_exit = function()
			active_job = nil
		end,
	})

	-- M.debug_curl(args)
	active_job:start()

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "LLM_Escape",
		callback = function()
			if active_job then
				active_job:shutdown()
				print("LLM streaming cancelled")
				active_job = nil
			end
		end,
	})

	vim.api.nvim_set_keymap("n", "<Esc>", ":doautocmd User LLM_Escape<CR>", { noremap = true, silent = true })
	return active_job
end

function M.debug_curl(args)
	local all_output = {}
	local debug_job = Job:new({
		command = "curl",
		args = args,
		on_stdout = function(_, out)
			table.insert(all_output, "STDOUT: " .. out)
		end,
		on_stderr = function(_, err)
			table.insert(all_output, "STDERR: " .. err)
		end,
		on_exit = function()
			vim.schedule(function()
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_output)
				vim.api.nvim_command("vsplit")
				vim.api.nvim_win_set_buf(0, buf)
			end)
		end,
	})
	debug_job:sync()
end

return M
