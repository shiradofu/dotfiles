local g = vim.api.nvim_create_augroup
local c = vim.api.nvim_create_autocmd
local m = require 'user.mappings'

local qf = g('FtQuickfix', {})
c('FileType', { group = qf, pattern = 'qf', callback = m.ft_quickfix })

local http = g('FtHttp', {})
c('FileType', { group = http, pattern = 'http', callback = m.ft_http })

local md = g('FtMarkdown', {})
c('BufEnter', {
  group = md,
  pattern = '*.md',
  callback = function()
    m.ft_markdown()
    vim.cmd [[
      syntax match checkedItem containedin=ALL '\v\s*(-\s+)?\[x\]\s+.*'
      hi link checkedItem Comment
    ]]
  end,
})

local template = g('FtTemplate', {})
c('BufEnter', {
  group = template,
  pattern = '*/dotfiles/data/templates/*',
  command = 'let b:enable_auto_format = v:false',
})
