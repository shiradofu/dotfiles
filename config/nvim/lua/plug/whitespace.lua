local function do_hl()
  local hl_decimal = vim.api.nvim_get_hl_by_name('Error', true).foreground
  local hl_hex = string.format('#%x', hl_decimal)
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { fg = hl_hex, bg = hl_hex })
end

return function()
  vim.g.better_whitespace_enabled = 1
  vim.g.strip_whitespace_on_save = 1
  vim.g.strip_whitespace_confirm = 0
  vim.g.strip_only_modified_lines = 1
  vim.g.show_spaces_that_precede_tabs = 1

  local g = vim.api.nvim_create_augroup('MyWhiteSpace', {})
  vim.api.nvim_create_autocmd('BufEnter', {
    group = g,
    callback = do_hl,
  })
  do_hl()
end
