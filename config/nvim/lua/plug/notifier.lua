local ignore_str = {
  '[LSP] Format request failed, no matching language servers.',
  'warning: multiple different client offset_encodings',
}

return {
  'vigoux/notifier.nvim',
  lazy = false,
  config = function()
    local notifier = require 'notifier'
    notifier.setup {}
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, level, opts)
      if vim.tbl_contains(ignore_str, msg) then return end
      notifier.notify(msg, level, opts)
    end
  end,
}
