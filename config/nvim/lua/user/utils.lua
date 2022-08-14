local M = {}

function M.feedkeys(key, mode)
  key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(key, mode, false)
end

function M.get(table, key, default)
  local val = table[key]
  if val == nil then
    return default
  end
  return val
end

function M.req(modname, fn, ...)
  local va = { ... }
  return function()
    return require(modname)[fn](unpack(va))
  end
end

return M
