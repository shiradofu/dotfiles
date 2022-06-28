local k = vim.keymap.set
local opt = { noremap = true, silent = true,  buffer = true }
local fmt_group = vim.api.nvim_create_augroup("LspFormatting", {})

--- vim.lsp.buf.format() 対応のためにやや冗長な実装をしている
--@param config
-- fmt_fn:  vim.lsp.buf.format() が実装されたらこちらのみにする
-- fmt_off: LS 自体の formatting 機能をオフにする、nvim < 0.8
return function(config)
  config = config or {}
  local fmt_fn = config.fmt_fn or vim.lsp.buf.formatting_sync
  return function(client, bufnr)
    k('n', 'gd', vim.lsp.buf.definition, opt)
    k('n', 'gD', vim.lsp.buf.implementation, opt)
    k('n', 'gr', vim.lsp.buf.rename, opt)
    k('n', 'ga', vim.lsp.buf.code_action, opt)
    k('n', 'K', vim.lsp.buf.hover, opt)
    k('n', '<leader>n', vim.lsp.buf.references, opt)
    k('n', '=', fmt_fn, opt)

    if config.fmt_off then
      client.resolved_capabilities.document_formatting = false
    end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_group,
        buffer = bufnr,
        callback = function() fmt_fn({ bufnr = bufnr }) end,
      })
    end
  end
end
