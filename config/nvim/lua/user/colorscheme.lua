local g = vim.api.nvim_create_augroup
local c = vim.api.nvim_create_autocmd
vim.g.material_style = 'lighter'

local function hl(name, val) vim.api.nvim_set_hl(0, name, val) end

local function all()
  -- lewis6991/gitsigns.nvim
  hl('GitSignsAddNr', { link = 'DiffAdd' })
  hl('GitSignsChangeNr', { link = 'DiffChange' })
  hl('GitSignsDeleteNr', { link = 'DiffDelete' })
  hl('GitSignsChangeDeleteNr', { link = 'DiffChange' })

  -- folke/flash.nvim
  hl('FlashLabel', { fg = '#ff0000', underline = true })

  hl('Search', { fg = '#161821', bg = '#c6c8d1' })
  hl('IncSearch', { fg = '#392313', bg = '#e4aa80' })
end

all()

local aug = g('MyColorScheme', {})
c('ColorScheme', { group = aug, pattern = '*', callback = all })

local function iceberg()
  hl('Search', { fg = '#161821', bg = '#c6c8d1' })
  hl('IncSearch', { fg = '#392313', bg = '#e4aa80' })
end
c('ColorScheme', { group = aug, pattern = 'iceberg', callback = iceberg })
