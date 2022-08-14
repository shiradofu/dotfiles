local mappings = require 'user.mappings'

local before_zen = { wins = {}, tabs = {} }

require('zen-mode').setup {
  on_open = function()
    before_zen.wins = vim.tbl_filter(function(win)
      return vim.api.nvim_win_get_config(win).relative == ''
    end, vim.api.nvim_tabpage_list_wins(0))
    before_zen.tabs = vim.api.nvim_list_tabpages()

    for key in string.gmatch('hjklnp', '.') do
      pcall(vim.keymap.del, 'n', '<C-' .. key .. '>')
    end
  end,
  on_close = function()
    mappings.win_move()
    mappings.tab_move()

    -- 新しいウィンドウやタブが生成されていたらそちらに移動
    local new_wins = vim.tbl_filter(function(win)
      return not vim.tbl_contains(before_zen.wins, win)
    end, vim.api.nvim_tabpage_list_wins(0))
    if #new_wins > 0 then
      return vim.defer_fn(function()
        vim.api.nvim_set_current_win(new_wins[1])
      end, 0)
    end

    local new_tabs = vim.tbl_filter(function(tab)
      return not vim.tbl_contains(before_zen.tabs, tab)
    end, vim.api.nvim_list_tabpages())
    if #new_tabs > 0 then
      return vim.defer_fn(function()
        vim.api.nvim_set_current_tabpage(new_tabs[1])
      end, 0)
    end
  end,
}
