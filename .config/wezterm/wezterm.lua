local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  font_size = 18,
  font = wezterm.font_with_fallback {
    { family = 'SF Mono Square', weight = 1000 },
  },
  window_background_opacity = tonumber '0.9',
  color_scheme = 'zenwritten_dark',
  enable_kitty_keyboard = true,
}
