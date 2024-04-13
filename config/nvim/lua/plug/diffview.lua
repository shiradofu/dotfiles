local win = require 'user.win'

vim.api.nvim_create_user_command('DiffviewWorkspace', function(ctx)
  local kind = ctx.args
  if kind == 'git_status' then
    win.reuse('tab', 'is_git_status', 'DiffviewOpen')
  elseif kind == 'diff_by_main' then
    win.reuse('tab', 'is_diff_by_main', 'DiffviewOpen main')
  elseif kind == 'all_files_history' then
    win.reuse('tab', 'is_all_files_hist', 'DiffviewFileHistory')
  else
    vim.notify('Wrong argument for DiffviewWorkspace: ' .. kind, 'error')
  end
end, { nargs = 1 })

---@param fn function
---@param ms number
local function debounce(fn, ms)
  local timer = vim.loop.new_timer()
  return function()
    timer:start(ms, 0, function() pcall(vim.schedule_wrap(fn)) end)
  end
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local a = require 'diffview.actions'
    local lib = require 'diffview.lib'
    local LogEntry = require('diffview.vcs.log_entry').LogEntry

    local debounced_select_entry = debounce(a.select_entry, 50)

    require('diffview').setup {
      hooks = {
        view_enter = function(view)
          local p = view.panel
          local path_args = p.adapter.ctx.path_args
          -- path にファイルを指定したかどうか
          local file_given = #path_args == 1
            and vim.fn.filereadable(path_args[1])
          -- visual モードで範囲を指定したかどうか
          local range_given = p.log_options
            and #p.log_options.single_file.L == 1

          if file_given or range_given then
            vim.t.diffview_single_file = true
          end

          -- 単体ファイルの diff を表示するときはファイル一覧を閉じておく
          if vim.bo.ft == 'DiffviewFiles' and vim.t.diffview_single_file then
            a.toggle_files()
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
          ['<BS>'] = win.tabclose,
        },
        file_panel = {
          ['j'] = function()
            vim.cmd [[normal! j]]
            debounced_select_entry()
          end,
          ['k'] = function()
            vim.cmd [[normal! k]]
            debounced_select_entry()
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
          ['-'] = function() vim.cmd [[wincmd 2-]] end,
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
            while not entry:instanceof(LogEntry) and vim.fn.line '.' ~= 5 do
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
  end,
}
