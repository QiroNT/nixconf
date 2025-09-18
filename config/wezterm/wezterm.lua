local wezterm = require 'wezterm'
local config = {}

config.initial_cols = 140
config.initial_rows = 45

config.font = wezterm.font_with_fallback {
  {
    family = 'MonaspiceNe Nerd Font',
    harfbuzz_features = {'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'},
  },
  {
    family = 'Monaspace Neon',
    harfbuzz_features = {'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'},
  },
  'NotoSansMono Nerd Font',
}
config.font_size = 11.0

config.enable_scroll_bar = true

-- https://github.com/wezterm/wezterm/issues/6831
config.enable_wayland = false

config.check_for_updates = false

return config
