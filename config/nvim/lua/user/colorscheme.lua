local g = vim.api.nvim_create_augroup
local c = vim.api.nvim_create_autocmd
vim.g.material_style = 'lighter'

local function hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

local cache_dir = vim.fn.stdpath 'cache'

math.randomseed(os.time())
while
  not pcall(
    vim.fn.serverstart,
    string.format('%s/server-%d.pipe', cache_dir, math.random(49152, 65535))
  )
do
end

local function pounce()
  if vim.o.background == 'dark' then
    hl('PounceUnmatched', { fg = '#666666' })
    hl('PounceGap', { fg = '#888888' })
    hl('PounceMatch', { fg = '#BBBBBB' })
    hl('PounceAccept', { fg = '#FFAF60', bold = true })
    hl('PounceAcceptBest', { fg = '#FF0000', bold = true })
  else
    hl('PounceUnmatched', { fg = '#AAAAAA' })
    hl('PounceGap', { fg = '#888888' })
    hl('PounceMatch', { fg = '#777777' })
    hl('PounceAccept', { fg = '#026cf7', bold = true })
    hl('PounceAcceptBest', { fg = '#FF0000', bold = true })
  end
end

local aug = g('MyColorScheme', {})
c('ColorScheme', { group = aug, pattern = '*', callback = pounce })