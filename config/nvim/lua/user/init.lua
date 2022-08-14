local find_root = require 'user.find-root'

-- バッファのレポジトリルートに移動
local root = vim.api.nvim_create_augroup('MyRoot', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = root,
  pattern = '*',
  callback = function(e)
    local parent = vim.loop.fs_realpath(e.file .. '/../')
    if not parent then
      return
    end
    local git_root = find_root('/%.git$', parent)
    if git_root then
      vim.cmd('lcd ' .. git_root)
    end
  end,
})

-- quickfix は常に botright で開く
local cmd = vim.cmd
vim.cmd = function(str)
  if str == 'copen' then
    return cmd [[botright copen]]
  end
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
