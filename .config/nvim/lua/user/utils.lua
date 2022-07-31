local M = {}

function M.feedkeys(key, mode)
  key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(key, mode, false)
end

function M.req(modname, fn, ...)
  local va = { ... }
  return function()
    return require(modname)[fn](unpack(va))
  end
end
return M
