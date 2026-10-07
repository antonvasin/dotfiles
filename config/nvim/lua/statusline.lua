-- Width-aware lualine. On narrow windows parts give way in this order:
--   encoding/fileformat (< 100 cols), branch (trimmed from the left), parent dir (trimmed with …),
--   progress, filetype, diff, diagnostics.
-- Mode, location and the file's basename always stay. Every render records how wide these parts
-- want to be; right after it the rendered line is measured and, if the layout should change,
-- lualine renders once more.
local M = {}

local stl = { win = {} }
local stl_drop_order = { "progress", "filetype", "diff", "diagnostics" }
-- A section emptied by hiding its parts takes its separator with it.
local stl_sections = { { "branch", "diff", "diagnostics" }, { "filetype", wide = true }, { "progress" } }
local dw = vim.api.nvim_strwidth -- not strdisplaywidth: that adds 'showbreak' in narrow windows

-- 'nvim' -> 'nv…'
local function trim_end(s, w)
  return vim.fn.strcharpart(s, 0, w - 1) .. "…"
end

-- 'feature/statusline-tweaks' -> '…tweaks'
local function trim_start(s, w)
  return "…" .. vim.fn.strcharpart(s, vim.fn.strchars(s) - (w - 1))
end

local function stl_wide(win)
  return vim.api.nvim_win_get_width(win or 0) >= 100
end

-- Per window and 'active'/'inactive': wanted widths, rendered widths and the layout in use.
-- All widths include lualine's padding.
local function stl_state(kind)
  local win = vim.api.nvim_get_current_win()
  stl.win[win] = stl.win[win] or {}
  stl.win[win][kind] = stl.win[win][kind] or { nat = {}, shown = {}, layout = { hide = {} } }
  return stl.win[win][kind], win
end

-- Start from every part at full width and take parts away, in order, until `over` (columns
-- beyond the window width) is gone.
local function stl_layout(s, over, wide)
  local nat, layout = s.nat, { hide = {} }
  local function hide(name)
    layout.hide[name] = true
    over = over - (nat[name] or 0)
    for _, sec in ipairs(stl_sections) do
      if vim.tbl_contains(sec, name) and (nat[name] or 0) > 0 and not (sec.wide and wide) then
        local empty = true
        for _, n in ipairs(sec) do
          empty = empty and (layout.hide[n] or (nat[n] or 0) == 0)
        end
        if empty then
          over = over - 1 -- the section's separator goes too
        end
      end
    end
  end

  local branch, parent = nat.branch or 0, nat.parent or 0
  if over > 0 and branch > 0 then
    if branch - over - 4 >= 6 then
      layout.branch = branch - over - 4 -- room for the name, without icon and padding
      return layout
    end
    hide("branch")
  end
  if over > 0 and parent > 0 then
    if parent - over >= 3 then
      layout.parent = parent - over -- room for 'parent/'
      return layout
    end
    layout.parent = 0
    over = over - parent
  end
  for _, name in ipairs(stl_drop_order) do
    if over <= 0 then
      break
    end
    hide(name)
  end
  return layout
end

local function stl_measure(win)
  local st = stl.win[win]
  if not st or not vim.api.nvim_win_is_valid(win) then
    return
  end
  st.pending = nil
  local s = st[st.kind]
  local wide = stl_wide(win)
  local str = vim.api.nvim_get_option_value("statusline", { win = win }):gsub("%%=", "")
  -- Width of the line with every part at full width.
  local full = vim.api.nvim_eval_statusline(str, { winid = win, maxwidth = 1000 }).width
  for _, w in pairs(s.shown) do
    full = full - w
  end
  for _, w in pairs(s.nat) do
    full = full + w
  end
  if st.kind == "active" then
    for _, sec in ipairs(stl_sections) do
      local now = sec.wide and wide
      local all = now
      for _, name in ipairs(sec) do
        now = now or (s.shown[name] or 0) > 0
        all = all or (s.nat[name] or 0) > 0
      end
      if all and not now then
        full = full + 1 -- separator of a section that's currently hidden
      end
    end
  end
  local layout = stl_layout(s, full - vim.api.nvim_win_get_width(win), wide)
  if not vim.deep_equal(layout, s.layout) then
    s.layout = layout
    -- force renders now instead of queueing; the corrective render isn't measured again
    stl.correcting = true
    pcall(require('lualine').refresh, { place = { 'statusline' }, force = true })
    stl.correcting = false
  end
end

local function smart_file(kind)
  return function()
    local s, win = stl_state(kind)
    local name = vim.fn.expand("%:t")
    local flags = {}
    if vim.bo.modified then
      table.insert(flags, "[+]")
    end
    if not vim.bo.modifiable or vim.bo.readonly then
      table.insert(flags, "[-]")
    end
    local base = (name ~= "" and name or "[No Name]") .. (#flags > 0 and " " .. table.concat(flags) or "")
    local is_file = name ~= "" and vim.bo.buftype == "" and not vim.api.nvim_buf_get_name(0):match("^%a+://")
    local parent = is_file and vim.fn.expand("%:p:h:t") or ""
    s.nat.base = dw(base) + 2
    s.nat.parent = parent ~= "" and dw(parent) + 1 or 0

    local room = s.layout.parent
    if room and s.nat.parent > room then
      parent = room >= 3 and trim_end(parent, room - 1) or ""
    end
    local text = (parent ~= "" and parent .. "/" or "") .. base
    s.shown.file = dw(text) + 2

    stl.win[win].kind = kind
    if not stl.correcting and not stl.win[win].pending then
      stl.win[win].pending = true
      vim.schedule(function() stl_measure(win) end)
    end
    return (text:gsub("%%", "%%%%"))
  end
end

local function smart_branch(name)
  local s = stl_state("active")
  s.nat.branch = name ~= "" and dw(name) + 4 or 0 -- icon, space and padding
  local room = s.layout.branch
  if s.layout.hide.branch then
    name = ""
  elseif room and dw(name) > room then
    name = trim_start(name, room)
  end
  s.shown.branch = name ~= "" and dw(name) + 4 or 0
  return name
end

-- fmt for built-in components that may be hidden
local function stl_drop(name)
  return function(str)
    local s = stl_state("active")
    s.nat[name] = str ~= "" and vim.api.nvim_eval_statusline(str, { maxwidth = 1000 }).width + 2 or 0
    s.shown[name] = s.layout.hide[name] and 0 or s.nat[name]
    return s.layout.hide[name] and "" or str
  end
end

function M.setup()
  local stl_group = vim.api.nvim_create_augroup("SmartStatusline", { clear = true })
  vim.api.nvim_create_autocmd("WinResized", {
    group = stl_group,
    callback = function()
      require('lualine').refresh({ place = { 'statusline' } })
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = stl_group,
    callback = function(args)
      stl.win[tonumber(args.match)] = nil
    end,
  })

  local cmake = require("cmake-tools")
  require('lualine').setup({
    options = {
      component_separators = "",
    },
    inactive_sections = {
      lualine_c = { smart_file("inactive") },
      lualine_x = { "location" },
    },
    sections = {
      lualine_b = {
        { "branch", fmt = smart_branch },
        { "diff", fmt = stl_drop("diff") },
        { "diagnostics", fmt = stl_drop("diagnostics") },
      },
      lualine_x = {
        { "encoding", cond = stl_wide },
        { "fileformat", cond = stl_wide },
        { "filetype", fmt = stl_drop("filetype") },
      },
      lualine_y = { { "progress", fmt = stl_drop("progress") } },
      lualine_c = {
        smart_file("active"),
        {
          function()
            local c_preset = cmake.get_configure_preset()
            return "CMake: [" .. (c_preset and c_preset or "X") .. "]"
          end,
          icon = "",
          cond = function()
            return cmake.is_cmake_project() and cmake.has_cmake_preset()
          end,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectConfigurePreset")
              end
            end
          end
        },
        {
          function()
            local type = cmake.get_build_type()
            return "CMake: [" .. (type and type or "") .. "]"
          end,
          icon = "",
          cond = function()
            return cmake.is_cmake_project() and not cmake.has_cmake_preset()
          end,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectBuildType")
              end
            end
          end
        },
        {
          function()
            local kit = cmake.get_kit()
            return "[" .. (kit and kit or "X") .. "]"
          end,
          icon = "",
          cond = function()
            return cmake.is_cmake_project() and not cmake.has_cmake_preset()
          end,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectKit")
              end
            end
          end
        },
        {
          function()
            return "Build"
          end,
          cond = cmake.is_cmake_project,
          icon = "󰣪",
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeBuild")
              end
            end
          end
        },
        {
          function()
            local b_preset = cmake.get_build_preset()
            return "[" .. (b_preset and b_preset or "X") .. "]"
          end,
          cond = function()
            return cmake.is_cmake_project() and cmake.has_cmake_preset()
          end,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectBuildPreset")
              end
            end
          end
        },
        {
          function()
            local b_target = cmake.get_build_target()
            return "[" .. (b_target and b_target or "X") .. "]"
          end,
          cond = cmake.is_cmake_project,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectBuildTarget")
              end
            end
          end
        },
        {
          function()
            return ""
          end,
          cond = cmake.is_cmake_project,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeDebug")
              end
            end
          end
        },
        {
          function()
            return ""
          end,
          cond = cmake.is_cmake_project,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeRun")
              end
            end
          end
        },
        {
          function()
            local l_target = cmake.get_launch_target()
            return "[" .. (l_target and l_target or "X") .. "]"
          end,
          cond = cmake.is_cmake_project,
          on_click = function(n, mouse)
            if (n == 1) then
              if (mouse == "l") then
                vim.cmd("CMakeSelectLaunchTarget")
              end
            end
          end
        }
      }
    }
  })
end

return M
