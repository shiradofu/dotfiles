local mappings = require 'user.mappings'
local ts_map = mappings.treesitter_textobjects
local ctx_comment_map = mappings.commentary()

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = { enable = true },
  indent = { enable = false },
  yati = { enable = true },
  endwise = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = ts_map,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
    },
  },
  context_commentstring = {
    enable = true,
    commentary_integration = ctx_comment_map,
    config = {
      cpp = { __default = '// %s', __multiline = '/* %s */' },
    },
  },
}
