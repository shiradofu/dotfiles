local W = {}

function W.close()
  if not pcall(vim.api.nvim_win_close, false) then
    local ok, v = pcall(vim.cmd, 'quit')
    if not ok then
      print(vim.trim(v))
    end
  end
end

return W
