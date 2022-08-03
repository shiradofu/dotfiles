local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local function is_windows()
  return package.config:sub(1, 1) == '\\'
end

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  use_ime = true,
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  font_size = 18,
  font = wezterm.font_with_fallback {
    { family = 'SF Mono Square', weight = 1000 },
  },
  keys = (function()
    local keys = {}
    for c in
      string.gmatch([[`1234567890-=qwertyuiopasdfghjkl;'zxcvbnm,./]], '.')
    do
      keys[#keys + 1] = {
        key = c,
        mods = 'CMD',
        action = act.SendKey { key = c, mods = 'ALT' },
      }
      keys[#keys + 1] = {
        key = c,
        mods = 'CMD|SHIFT',
        action = act.SendKey { key = c, mods = 'ALT|SHIFT' },
      }
      keys[#keys + 1] = {
        key = c,
        mods = 'CMD|CTRL',
        action = act.SendKey { key = c, mods = 'ALT|CTRL' },
      }
    end
    return keys
  end)(),
  default_prog = is_windows() and { 'wsl.exe' } or { 'zsh' },
  window_background_opacity = tonumber 'WEZTERM_OPACITY',
  color_scheme = 'WEZTERM_COLOR',
}
