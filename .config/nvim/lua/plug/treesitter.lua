local mappings = require('user.mappings').treesitter()

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
    disable = { 'markdown' },
    additional_vim_regex_highlighting = { 'markdown' },
  },
  indent = { enable = false },
  yati = {
    enable = true,
    disable = { 'markdown', 'php' },
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = mappings.textobjects,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = mappings.motion.next,
      goto_previous_start = mappings.motion.prev,
    },
  },
  context_commentstring = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     node_incremental = "v",
  --     node_decremental = "V",
  --   },
  -- },
}
