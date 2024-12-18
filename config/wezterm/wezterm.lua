local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Comfy")
config.font_size = 14.0
-- config.color_scheme = "Papercolor Dark (Gogh)"
config.audible_bell = "Disabled"

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Papercolor Dark (Gogh)"
  else
    return "Papercolor Light (Gogh)"
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.native_macos_fullscreen_mode = true

config.initial_cols = 120
config.initial_rows = 50

config.keys = {
  {
    key = "h",
    mods = "CTRL|CMD",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "CTRL|CMD",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "k",
    mods = "CTRL|CMD",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "j",
    mods = "CTRL|CMD",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "h",
    mods = "CTRL|CMD|ALT",
    action = wezterm.action.SplitPane({
      direction = "Left",
      size = { Percent = 40 },
    }),
  },
  {
    key = "l",
    mods = "CTRL|CMD|ALT",
    action = wezterm.action.SplitPane({
      direction = "Right",
      size = { Percent = 40 },
    }),
  },
  {
    key = "k",
    mods = "CTRL|CMD|ALT",
    action = wezterm.action.SplitPane({
      direction = "Up",
    }),
  },
  {
    key = "j",
    mods = "CTRL|CMD|ALT",
    action = wezterm.action.SplitPane({
      direction = "Down",
    }),
  },
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "f",
    mods = "CTRL|CMD",
    action = wezterm.action.ToggleFullScreen,
  },
  -- {
  -- 	key = "r",
  -- 	mods = "CMD",
  -- 	action = wezterm.action.DisableDefaultAssignment,
  -- },
  {
    key = "r",
    mods = "CMD",
    action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
  },
}

return config
