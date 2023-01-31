local function do_hl()
  vim.api.nvim_set_hl(0, 'CleverF', { fg = '#ff0000', underline = true })
end

return function()
  vim.g.clever_f_not_overwrites_standard_mappings = 1
  vim.g.clever_f_across_no_line = 1
  vim.g.clever_f_mark_char = 1
  vim.g.clever_f_mark_char_color = 'CleverF'

  local g = vim.api.nvim_create_augroup('MyCleverF', {})
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = g,
    callback = do_hl,
  })
  do_hl()
end
