local M = {}

-- Function to mark all section dividers with consecutive marks (a-z)
function M.mark_sections()
  -- Start with mark 'a'
  local mark_index = string.byte('a')
  local max_mark = string.byte('z')

  -- Find all section markers and set marks
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    -- Check if line contains section marker pattern
    if line:match("/+%s*%w+") and string.len(line:match("/+")) >= 8 then
      if mark_index <= max_mark then
        -- Set mark at this line
        vim.api.nvim_buf_set_mark(bufnr, string.char(mark_index), i, 0, {})
        mark_index = mark_index + 1
      else
        -- We've used all available marks
        vim.notify("Used all available marks (a-z)", vim.log.levels.WARN)
        break
      end
    end
  end

  vim.notify(string.format("Set %d section marks", mark_index - string.byte('a')))
end

-- Create keymapping to trigger mark_sections function
-- vim.keymap.set('n', '<leader>ms', mark_sections, { desc = "Mark all code sections" })

-- Optional: Automatically mark sections when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.c", ".h", ".cpp", ".java", ".js", ".ts", ".jsx", ".tsx", ".zig", ".css" },
  callback = function()
    mark_sections()
  end,
})

-- Existing keymaps for ]' and [' should work for navigation
-- But you can also create custom ones if preferred:
vim.keymap.set('n', '<leader>mn', "]'", { desc = "Next section mark" })
vim.keymap.set('n', '<leader>mp', "['", { desc = "Previous section mark" })

return M
