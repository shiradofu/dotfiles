M = {}

function M.style()
  vim.o.fileformat = 'unix'
  vim.o.tabstop = 4
  vim.o.shiftwidth = 2
  vim.o.expandtab = true
end
M.style()

return M
