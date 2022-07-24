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
    files = {
      -- providers that inherit these actions:
      --   files, git_files, git_status, grep, lsp, oldfiles,
      --   quickfix, loclist, tags, btags, args
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-x'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
      ['ctrl-q'] = actions.file_sel_to_qf,
    },
  },
  previewers = {
    bat = {
      theme = 'Coldark-Dark', -- TODO: read from env
    },
    git_diff = {
      pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
    },
  },
  file_icon_padding = ' ',
}

vim.lsp.handlers['textDocument/definition'] = function()
  fzf.lsp_definitions { jump_to_single_result = true }
end

vim.lsp.handlers['textDocument/references'] = function()
  fzf.lsp_references()
end
