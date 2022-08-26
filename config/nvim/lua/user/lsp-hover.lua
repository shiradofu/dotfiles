return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum = pos[1] - 1
  local col = pos[2]
  local diagnostic_exsists = #vim.tbl_filter(function(d)
    local x = d.bufnr == bufnr and lnum >= d.lnum and lnum <= d.end_lnum
    if not x then return false end
    if lnum == d.lnum and d.lnum == d.end_lnum then
      return col >= d.col and col < d.end_col
    end
    if lnum > d.lnum and lnum < d.end_lnum then return x end
    if lnum == d.lnum then return col >= d.col end
    if lnum == d.end_lnum then return col < d.end_col end
  end, vim.diagnostic.get()) > 0

  if diagnostic_exsists then
    pcall(vim.diagnostic.open_float)
  else
    pcall(vim.lsp.buf.hover)
  end
end
