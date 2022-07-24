local mappings = require 'user.mappings'
require('zen-mode').setup {
  on_open = function()
    for _, key in ipairs {
      'h',
      'j',
      'k',
      'l',
      'n',
      'p',
    } do
      pcall(vim.keymap.del, 'n', '<C-' .. key .. '>')
    end
  end,
  on_close = function()
    mappings.win_move()
    mappings.tab_move()
  end,
}
