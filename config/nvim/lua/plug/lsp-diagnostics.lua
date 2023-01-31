local M = {} -- keys are filetypes

-- fallback
M._ = function() end

M.sh = function(_, bufnr)
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
  if
    vim.tbl_contains({
      '.env',
      '.env.example',
      '.env.local',
      '.env.testing',
    }, name)
  then
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
  end
end

local function is_another_hover_win_existing()
  local ok, winnr = pcall(vim.api.nvim_buf_get_var, 0, 'lsp_floating_preview')
  return ok and vim.api.nvim_win_is_valid(winnr)
end

-- Diagnostics の上にカーソルがあれば自動的に表示
-- vim.lsp.buf.hover() が表示されている間は表示しない
local g = vim.api.nvim_create_augroup('MyDiagnostics', {})
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  group = g,
  callback = function()
    if vim.lsp.buf.server_ready() and not is_another_hover_win_existing() then
      vim.diagnostic.open_float()
    end
  end,
})

return M
