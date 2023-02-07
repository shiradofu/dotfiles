local g = vim.api.nvim_create_augroup
local c = vim.api.nvim_create_autocmd
vim.g.material_style = 'lighter'

local function hl(name, val) vim.api.nvim_set_hl(0, name, val) end

local function all()
  -- pounce
  if vim.o.background == 'dark' then
    hl('PounceUnmatched', { fg = '#4A4A4A' })
    hl('PounceGap', { fg = '#888888' })
    hl('PounceMatch', { fg = '#E9E9E9' })
    hl('PounceAccept', { fg = '#FFAF60', bold = true })
    hl('PounceAcceptBest', { fg = '#FF0000', bold = true })
  else
    hl('PounceUnmatched', { fg = '#BBBBBB' })
    hl('PounceGap', { fg = '#888888' })
    hl('PounceMatch', { fg = '#555555' })
    hl('PounceAccept', { fg = '#026cf7', bold = true })
    hl('PounceAcceptBest', { fg = '#FF0000', bold = true })
  end

  -- gitsigns
  hl('GitSignsAddNr', { link = 'DiffAdd' })
  hl('GitSignsChangeNr', { link = 'DiffChange' })
  hl('GitSignsDeleteNr', { link = 'DiffDelete' })
  hl('GitSignsChangeDeleteNr', { link = 'DiffChange' })

  -- clever-f
  hl('CleverF', { fg = '#ff0000', underline = true })
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
