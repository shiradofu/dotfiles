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

-- QuickFix は常に下に表示する
-- サイズは最小5行、最大画面の高さの2割
local qf = vim.api.nvim_create_augroup('FtQuickfix', {})
vim.api.nvim_create_autocmd('FileType', {
  group = qf,
  pattern = 'qf',
  callback = function()
    vim.cmd.wincmd 'J'
    local min_height = 5
    local max_height = math.floor(vim.o.lines * 0.2)
    local item_num = #vim.fn.getqflist()
    local height = min_height
    if item_num + 1 > min_height then height = item_num + 1 end
    if max_height > min_height and height > max_height then
      height = max_height
    end
    vim.api.nvim_win_set_height(0, height)
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

-- テンプレートと karabiner-elements は自動フォーマットしない
local template = vim.api.nvim_create_augroup('FtTemplate', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = template,
  pattern = { '*/dotfiles/data/templates/*', '*/karabiner/karabiner.json' },
  command = 'let b:enable_auto_format = v:false',
})
