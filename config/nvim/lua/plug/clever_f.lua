return {
  'rhysd/clever-f.vim',
  keys = { '<Plug>(clever-f-' },
  init = function()
    vim.g.clever_f_not_overwrites_standard_mappings = 1
    vim.g.clever_f_across_no_line = 1
    vim.g.clever_f_mark_char = 1
    vim.g.clever_f_mark_char_color = 'CleverF'
  end,
}
