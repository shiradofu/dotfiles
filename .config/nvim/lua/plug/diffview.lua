local fn = vim.fn
local a = require 'diffview.actions'
local lib = require 'diffview.lib'
local LogEntry = require('diffview.git.log_entry').LogEntry

require('diffview').setup {
  hooks = {
    view_enter = function(view)
      if fn.bufname():find [[^diffview:///]] ~= nil then
        if vim.bo.ft ~= 'DiffviewFiles' then
          a.focus_files()
        end
      end
      local p = view.panel
      if not p.rev_pretty_name and #p.path_args == 0 then
        vim.cmd [[set filetype=gitstatus]]
        vim.cmd [[file Git status]]
      end
      if
        #p.path_args == 1
        and vim.fn.filereadable(vim.fn.fnamemodify(p.path_args[1], ':p')) == 1
      then
        vim.t.diffview_single_file = true
      end
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
      ['<BS>'] = fn['user#win#tabclose'],
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
        if not pcall(a.focus_entry) then
          vim.cmd [[wincmd p]]
        end
      end,
      ['<C-t>'] = a.goto_file_tab,
      ['<C-g>'] = a.toggle_files,
      ['<BS>'] = fn['user#win#tabclose'],
      ['r'] = a.refresh_files,
      ['a'] = a.toggle_stage_entry,
      ['A'] = a.stage_all,
      ['s'] = a.toggle_stage_entry,
      ['S'] = a.stage_all,
      ['U'] = a.unstage_all,
      ['dd'] = a.restore_entry,
    },
    file_history_panel = {
      ['j'] = function()
        vim.cmd [[normal! j]]
        if vim.t.diffview_single_file then
          pcall(a.select_entry)
        end
      end,
      ['k'] = function()
        vim.cmd [[normal! k]]
        if vim.t.diffview_single_file then
          pcall(a.select_entry)
        end
      end,
      ['l'] = function()
        if not pcall(a.select_entry) then
          return
        end
        local view = lib.get_current_view()
        if view.panel.single_file then
          return
        end
        local entry = view.panel:get_item_at_cursor()
        if entry and entry:instanceof(LogEntry) then
          a.next_entry()
        end
      end,
      ['h'] = function()
        local view = lib.get_current_view()
        local entry = view.panel:get_item_at_cursor()
        if not entry then
          return
        end
        while not entry:instanceof(LogEntry) and fn.line '.' ~= 5 do
          a.prev_entry()
          entry = view.panel:get_item_at_cursor()
        end
        entry.folded = true
        view.panel:render()
        view.panel:redraw()
      end,
      ['<cr>'] = a.focus_entry,
      ['go'] = a.goto_file,
      ['<C-g>'] = a.toggle_files,
      ['<BS>'] = fn['user#win#tabclose'],
      ['o'] = a.options,
      ['yy'] = a.copy_hash,
      ['L'] = a.open_commit_log,
    },
  },
}
