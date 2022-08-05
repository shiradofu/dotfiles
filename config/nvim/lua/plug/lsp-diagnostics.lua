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

return M
