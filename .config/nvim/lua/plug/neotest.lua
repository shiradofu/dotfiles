require('neotest').setup {
  adapters = {
    -- require 'neotest-jest',
    require 'neotest-vitest',
    require 'neotest-phpunit',
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

local logger = require 'neotest.logging'
logger:set_level 'trace'
