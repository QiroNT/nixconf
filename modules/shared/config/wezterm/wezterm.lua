local wezterm = require 'wezterm'
local config = {}

config.initial_cols = 140
config.initial_rows = 45

config.color_scheme = 'Tokyo Night'

config.font = wezterm.font_with_fallback {
  {
    family = 'MonaspiceNe Nerd Font',
    harfbuzz_features = {
      'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss08',
      'calt', 'dlig',
    },
  },
  {
    family = 'Monaspace Neon',
    harfbuzz_features = {
      'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss08',
      'calt', 'dlig',
    },
  },
  'NotoSansMono Nerd Font',
}
config.font_size = 11.0

config.enable_scroll_bar = true

return config
