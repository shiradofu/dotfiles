local a = require "diffview.actions"
local lib = require "diffview.lib"
local LogEntry = require("diffview.git.log_entry").LogEntry
-- local FileHistoryView =
--   require(
--     "diffview.views.file_history.file_history_view"
--   ).FileHistoryView

require("diffview").setup {
  hooks = {
    view_enter = function()
      if vim.fn.bufname():find [[^diffview:///]] ~= nil then
        if vim.bo.ft ~= "DiffviewFiles" then
          a.focus_files()
        end
      end
    end,
  },
  file_panel = {
    listing_style = "list",
    win_config = {
      position = "top",
      height = 10,
    },
  },
  keymaps = {
    disable_defaults = false,
    view = {
      ["<tab>"] = a.select_next_entry,
      ["<S-tab>"] = a.select_prev_entry,
      ["go"] = a.goto_file_tab,
      ["<C-g>"] = a.toggle_files,
      ["<C-t>"] = a.goto_file_tab,
      ["<C-o>"] = a.focus_files,
      ["<BS>"] = vim.fn["user#win#tabclose"],
    },
    file_panel = {
      ["j"] = function()
        vim.cmd [[normal! j]]
        pcall(a.select_entry)
      end,
      ["k"] = function()
        vim.cmd [[normal! k]]
        pcall(a.select_entry)
      end,
      ["l"] = a.select_entry,
      ["<cr>"] = a.focus_entry,
      ["<C-j>"] = a.focus_entry,
      ["go"] = a.goto_file_tab,
      ["<C-t>"] = a.goto_file_tab,
      ["<C-g>"] = a.toggle_files,
      ["<BS>"] = vim.fn["user#win#tabclose"],
      ["r"] = a.refresh_files,
      ["a"] = a.toggle_stage_entry,
      ["A"] = a.toggle_stage_entry,
      ["s"] = a.toggle_stage_entry,
      ["S"] = a.stage_all,
      ["U"] = a.unstage_all,
      ["dd"] = a.restore_entry,
    },
    file_history_panel = {
      ["l"] = function()
        a.select_entry()
        local view = lib.get_current_view()
        local entry = view.panel:get_item_at_cursor()
        if entry:instanceof(LogEntry) then
          a.next_entry()
        end
      end,
      ["h"] = function()
        local view = lib.get_current_view()
        local entry = view.panel:get_item_at_cursor()
        while not entry:instanceof(LogEntry) and vim.fn.line "." ~= 5 do
          a.prev_entry()
          entry = view.panel:get_item_at_cursor()
        end
        entry.folded = true
        view.panel:render()
        view.panel:redraw()
      end,
      ["<cr>"] = a.focus_entry,
      ["go"] = a.goto_file,
      ["<C-g>"] = a.toggle_files,
      ["<BS>"] = vim.fn["user#win#tabclose"],
      ["o"] = a.options,
      ["yy"] = a.copy_hash,
      ["L"] = a.open_commit_log,
      ["zR"] = a.open_all_folds,
      ["zM"] = a.close_all_folds,
    },
  },
}
