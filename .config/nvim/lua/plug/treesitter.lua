local mappings = require 'user.mappings'
local ts_map = mappings.treesitter()
local ctx_comment_map = mappings.commentary()

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
      keymaps = ts_map.textobjects,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = ts_map.motion.next,
      goto_previous_start = ts_map.motion.prev,
    },
  },
  context_commentstring = {
    enable = true,
    commentary_integration = ctx_comment_map,
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
