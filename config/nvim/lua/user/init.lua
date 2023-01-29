local find_root = require 'user.find-root'

-- バッファのリポジトリルートに移動
local root = vim.api.nvim_create_augroup('MyRoot', {})
vim.api.nvim_create_autocmd('VimEnter', {
  group = root,
  pattern = '*',
  callback = function()
    local git_root = find_root { '/%.git$', '/%.root$' }
    if git_root then vim.cmd('lcd ' .. git_root) end
  end,
})

-- quickfix は常に botright で開く
local cmd = vim.cmd
vim.cmd = function(str)
  if str == 'copen' then return cmd [[botright copen]] end
  return cmd(str)
end

-- 置換でのレジスタを上書きとハイライトを防止
local substitute = vim.api.nvim_create_augroup('MySubstitute', {})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '*',
  group = substitute,
  callback = function()
    if
      vim.v.event.cmdtype ~= ':'
      or vim.fn.bufname() == '[Command Line]'
      -- is substitution
      or not vim.fn.getcmdline():find [[s([^%w\| ]).*%1.*]]
    then
      return
    end

    local reg_save = vim.fn.getreg '/'
    vim.defer_fn(function()
      vim.fn.setreg('/', reg_save)
      vim.cmd 'nohl'
    end, 0)
  end,
})

-- Diff でないときにカーソル・スクロール同期することがあるのを防止
local nodiff = vim.api.nvim_create_augroup('NoDiff', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = nodiff,
  pattern = '*',
  callback = function()
    if not vim.o.diff then vim.cmd 'set nocursorbind | set noscrollbind' end
  end,
})

-- markdown のチェックボックスのハイライト
local md = vim.api.nvim_create_augroup('FtMarkdown', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = md,
  pattern = '*.md',
  callback = function()
    vim.cmd [[
      syntax match MdCheckedItem containedin=ALL '\v\s*(-\s+)?\[x\]\s+.*'
      hi link MdCheckedItem Comment
    ]]
  end,
})

-- テンプレートは自動フォーマットしない
local template = vim.api.nvim_create_augroup('FtTemplate', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = template,
  pattern = '*/dotfiles/data/templates/*',
  command = 'let b:enable_auto_format = v:false',
})
