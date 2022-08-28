local W = {}

function W.close()
  if not pcall(vim.api.nvim_win_close, false) then
    local ok, v = pcall(vim.cmd, 'quit')
    if not ok then print(vim.trim(v)) end
  end
end

---@param tag string
---@param callback string|function
function W.reuse(tag, callback)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.tbl_get(vim.w[win], tag) then
      return vim.api.nvim_set_current_win(win)
    end
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.tbl_get(vim.t[tab], tag) then
      return vim.api.nvim_set_current_tabpage(tab)
    end
  end
  if type(callback) == 'string' then return vim.cmd(callback) end
  if type(callback) == 'function' then return callback() end
end

return W
