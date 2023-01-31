local fn = vim.fn
local a = require 'diffview.actions'
local lib = require 'diffview.lib'
local LogEntry = require('diffview.vcs.log_entry').LogEntry
local win = require 'user.win'

require('diffview').setup {
  hooks = {
    view_enter = function(view)
      local p = view.panel
      -- path にファイルを指定したかどうか
      local file_given = (
        #p.path_args == 1
        and vim.fn.filereadable(vim.fn.fnamemodify(p.path_args[1], ':p')) == 1
      )
      -- visual モードで範囲を指定したかどうか
      local range_given = p.log_options and #p.log_options.single_file.L == 1

      if fn.bufname():find [[^diffview:///]] ~= nil then
        if vim.bo.ft ~= 'DiffviewFiles' then a.focus_files() end
      end

      -- 何も指定しなかったときは git status 相当の表示になる
      if not p.rev_pretty_name and #p.path_args == 0 and not range_given then
        vim.t.is_git_status = true
      end

      if file_given or range_given then vim.t.diffview_single_file = true end

      vim.t.door2note_open_fn = 'open_float'
    end,
  },
  file_panel = {
    listing_style = 'list',
    win_config = {
      position = 'top',
      height = 10,
    },
  },
  file_history_panel = {
    win_config = {
      position = 'top',
      height = 10,
    },
  },
  keymaps = {
    disable_defaults = false,
    view = {
      ['<tab>'] = a.select_next_entry,
      ['<S-tab>'] = a.select_prev_entry,
      ['<C-g>'] = a.toggle_files,
      ['<C-t>'] = a.goto_file_tab,
      ['<C-o>'] = a.focus_files,
      ['<C-k>'] = a.focus_files,
      ['<BS>'] = win.tabclose,
    },
    file_panel = {
      ['j'] = function()
        vim.cmd [[normal! j]]
        pcall(a.select_entry)
      end,
      ['k'] = function()
        vim.cmd [[normal! k]]
        pcall(a.select_entry)
      end,
      ['l'] = a.select_entry,
      ['<cr>'] = a.focus_entry,

      ['<C-j>'] = function()
        if not pcall(a.focus_entry) then vim.cmd [[wincmd p]] end
      end,
      ['<C-t>'] = a.goto_file_tab,
      ['<C-g>'] = a.toggle_files,
      ['<BS>'] = win.tabclose,
      ['r'] = a.refresh_files,
      ['a'] = a.toggle_stage_entry,
      ['A'] = a.stage_all,
      ['s'] = a.toggle_stage_entry,
      ['S'] = a.stage_all,
      ['u'] = a.toggle_stage_entry,
      ['U'] = a.unstage_all,
      ['dd'] = a.restore_entry,
    },
    file_history_panel = {
      ['j'] = function()
        vim.cmd [[normal! j]]
        if vim.t.diffview_single_file then pcall(a.select_entry) end
      end,
      ['k'] = function()
        vim.cmd [[normal! k]]
        if vim.t.diffview_single_file then pcall(a.select_entry) end
      end,
      ['l'] = function()
        if not pcall(a.select_entry) then return end
        local view = lib.get_current_view()
        if view.panel.single_file then return end
        local entry = view.panel:get_item_at_cursor()
        if entry and entry:instanceof(LogEntry) then a.next_entry() end
      end,
      ['h'] = function()
        local view = lib.get_current_view()
        local entry = view.panel:get_item_at_cursor()
        if not entry then return end
        while not entry:instanceof(LogEntry) and fn.line '.' ~= 5 do
          a.prev_entry()
          entry = view.panel:get_item_at_cursor()
        end
        entry.folded = true
        view.panel:render()
        view.panel:redraw()
      end,
      ['<CR>'] = a.focus_entry,
      ['go'] = a.goto_file,
      ['<C-g>'] = a.toggle_files,
      ['<BS>'] = win.tabclose,
      ['o'] = a.options,
      ['yy'] = a.copy_hash,
      ['L'] = a.open_commit_log,
    },
  },
}
