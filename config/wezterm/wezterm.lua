local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Term")
config.font_size = 15.0
config.color_scheme = "Papercolor Dark (Gogh)"

return config
