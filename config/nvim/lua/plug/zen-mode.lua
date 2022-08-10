local mappings = require 'user.mappings'

-- 新しいウィンドウやタブを開くものとは相性が悪いので先に閉じる
local function close_before(plugin_name)
  for _, mode in ipairs { 'n', 'v' } do
    for _, m in
      ipairs(vim.tbl_filter(function(map)
        return type(map.rhs) == 'string' and map.rhs:find(plugin_name)
      end, vim.api.nvim_get_keymap(mode)))
    do
      local rhs = nil
      if type(m.rhs) == 'string' then
        rhs = "<Cmd>lua require('zen-mode').close()<CR>" .. m.rhs
      end
      if type(m.rhs) == 'function' then
        rhs = function()
          require('zen-mode').close()
          m.rhs()
        end
      end
      vim.keymap.set(
        m.mode,
        m.lhs:gsub(vim.g.mapleader, '<Leader>'),
        rhs,
        { silent = true, buffer = true }
      )
    end
  end
end

require('zen-mode').setup {
  on_open = function()
    for _, key in ipairs { 'h', 'j', 'k', 'l', 'n', 'p' } do
      pcall(vim.keymap.del, 'n', '<C-' .. key .. '>')
    end

    close_before 'Diffview'
    close_before 'project-note'
  end,
  on_close = function()
    mappings.win_move()
    mappings.tab_move()
  end,
}
