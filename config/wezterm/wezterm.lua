local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local function is_unix() return package.config:sub(1, 1) == '/' end
local function is_windows() return package.config:sub(1, 1) == '\\' end
local function merge(base, ...)
  local tables = { ... }
  for _, t in ipairs(tables) do
    for k, v in pairs(t) do
      base[k] = v
    end
  end
end

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = {
  use_ime = true,
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  font = wezterm.font_with_fallback {
    { family = 'JetBrains Mono', weight = 500 },
    { family = 'SF Mono', weight = 500 },
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
  enable_csi_u_key_encoding = true,
}

local ok, color = pcall(require, '_color')
if ok then merge(config, color) end

if is_unix() then
  merge(config, {
    default_prog = { 'zsh' },
    font_size = 14,
  })
end

if is_windows() then
  merge(config, {
    default_prog = { 'wsl.exe', '~' },
    font_size = 11,
  })
end

return config
