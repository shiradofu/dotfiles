return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  cmd = { 'TSUpdate', 'TSUpdateSync' },
  dependencies = {
    'tpope/vim-commentary',
    'yioneko/nvim-yati', -- improve indentation
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
    {
      'RRethy/nvim-treesitter-endwise',
      ft = { 'ruby', 'lua', 'vim', 'sh', 'zsh' },
    },
  },
  config = function()
    local mappings = require 'user.mappings'
    local ts_map = mappings.treesitter_textobjects

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
    }
  end,
}
