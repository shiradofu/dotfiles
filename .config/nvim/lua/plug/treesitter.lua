require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {
    disable = { 'markdown' },
    additional_vim_regex_highlighting = { 'vim' },
  },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     node_incremental = "v",
  --     node_decremental = "V",
  --   },
  -- },
  indent = { enable = false },
  yati = { enable = true, disable = { 'markdown', 'php' } },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[['] = '@class.outer',
      },
    },
  },
  endwise = {
    enable = true,
  },
}
