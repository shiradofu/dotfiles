local fzf = require 'fzf-lua'
local actions = require 'fzf-lua.actions'

fzf.setup {
  winopts = {
    height = 0.9,
    width = 0.9,
    border = 'single',
    preview = {
      default = 'bat',
      vertical = 'down:50%:sharp',
      horizontal = 'right:55%:sharp',
    },
  },
  keymap = {
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-c'] = 'abort',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['ctrl-l'] = 'toggle-preview',
      ['ctrl-j'] = 'preview-page-down',
      ['ctrl-k'] = 'preview-page-up',
    },
  },
  actions = {
    -- These override the default tables completely
    -- no need to set to `false` to disable an action
    -- delete or modify is sufficient
    files = {
      -- providers that inherit these actions:
      --   files, git_files, git_status, grep, lsp
      --   oldfiles, quickfix, loclist, tags, btags
      --   args
      -- default action opens a single selection
      -- or sends multiple selection to quickfix
      -- replace the default action with the below
      -- to open all files whether single or multiple
      -- ["default"]     = actions.file_edit,
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-x'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
      ['ctrl-q'] = actions.file_sel_to_qf,
    },
  },
}

vim.lsp.handlers['textDocument/definition'] = function()
  fzf.lsp_definitions { jump_to_single_result = true }
end
