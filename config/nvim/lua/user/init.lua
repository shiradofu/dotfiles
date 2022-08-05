local find_root = require 'user.find-root'

local root = vim.api.nvim_create_augroup('Root', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = root,
  pattern = '*',
  callback = function()
    local git_root = find_root '/%.git$'
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
