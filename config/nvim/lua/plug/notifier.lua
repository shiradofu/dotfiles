local ignore_str = {
  '[LSP] Format request failed, no matching language servers.',
}
local ignore_patterns = {
  'warning: multiple different client offset_encodings',
}

return {
  'vigoux/notifier.nvim',
  lazy = false,
  config = function()
    local notifier = require 'notifier'
    notifier.setup {}
    vim.notify = function(msg, level, opts)
      if
        vim.tbl_contains(ignore_str, msg)
        or #vim.tbl_filter(
            function(pat) return msg:find(pat) end,
            ignore_patterns
          )
          > 0
      then
        return
      end
      notifier.notify(msg, level, opts)
    end
  end,
}
