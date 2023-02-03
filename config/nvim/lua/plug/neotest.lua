local util = require 'user.util'

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'haydenmeade/neotest-jest', ft = util.js_family },
    { 'marilari88/neotest-vitest', ft = util.js_family },
    { 'olimorris/neotest-phpunit', ft = 'php' },
    { 'nvim-neotest/neotest-go', ft = 'go' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        -- require 'neotest-jest',
        require 'neotest-vitest',
        require 'neotest-phpunit',
        require 'neotest-go' {
          experimental = { test_table = true },
        },
      },
      floating = {
        border = 'single',
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '┐',
        final_child_indent = ' ',
        final_child_prefix = '└',
        non_collapsible = '─',
        running = '◯',
        passed = '✓',
        failed = '✗',
        skipped = '-',
        unknown = '?',
      },
    }

    -- local logger = require 'neotest.logging'
    -- logger:set_level 'trace'
  end,
}
