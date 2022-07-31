local g = vim.api.nvim_create_augroup
local c = vim.api.nvim_create_autocmd
local m = require 'user.mappings'

local qf = g('FtQuickfix', {})
c('FileType', { group = qf, pattern = 'qf', callback = m.ft_quickfix })

local http = g('FtHttp', {})
c('FileType', { group = http, pattern = 'http', callback = m.ft_http })

local dotenv = g('FtDotenv', {})
c('BufEnter', {
  group = dotenv,
  pattern = '.env.*',
  command = 'setlocal ft=sh',
})

local gitcommit = g('FtGitCommit', {})
c('BufWinEnter', {
  group = gitcommit,
  pattern = '.git/COMMIT_EDITMSG',
  command = 'startinsert',
})

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

local cpp = g('FtCpp', {})
c('FileType', {
  group = cpp,
  pattern = 'cpp',
  command = [[setlocal commentstring=//\ %s]],
})

local php = g('FtPhp', {})
c('FileType', {
  group = php,
  pattern = 'php',
  command = [[setlocal commentstring=//\ %s]],
})

local toml = g('FtToml', {})
c('FileType', {
  group = toml,
  pattern = 'toml',
  command = [[setlocal commentstring=#\ %s]],
})
