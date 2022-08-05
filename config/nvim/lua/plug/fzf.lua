local fzf = require 'fzf-lua'
local actions = require 'fzf-lua.actions'
local path = require 'fzf-lua.path'

fzf.setup {
  winopts = {
    height = 0.9,
    width = 0.9,
    border = 'single',
  },
  fzf_opts = {
    ['--info'] = 'default',
  },
  keymap = {
    builtin = {
      ['<C-j>'] = 'preview-page-down',
      ['<C-k>'] = 'preview-page-up',
      ['<C-l>'] = 'toggle-preview',
    },
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-c'] = 'abort',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['ctrl-l'] = 'toggle-preview',
      ['ctrl-j'] = 'preview-down',
      ['ctrl-k'] = 'preview-up',
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
      ['ctrl-r'] = function(selected, opts)
        local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
        vim.cmd 'vsplit'
        vim.cmd('Fern . -reveal=' .. vim.fn.fnameescape(entry.path))
      end,
    },
  },
  previewers = {
    git_diff = {
      pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
    },
  },
  grep = {
    rg_glob = true,
  },
  file_icon_padding = ' ',
}

vim.lsp.handlers['textDocument/definition'] = function()
  fzf.lsp_definitions { jump_to_single_result = true }
end

vim.lsp.handlers['textDocument/references'] = function()
  fzf.lsp_references()
end
