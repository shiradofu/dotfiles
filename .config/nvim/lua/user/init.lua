-- quickfix は常に botright で開く
local cmd = vim.cmd
vim.cmd = function(str)
  if str == 'copen' then
    return cmd [[botright copen]]
  end
  return cmd(str)
end
