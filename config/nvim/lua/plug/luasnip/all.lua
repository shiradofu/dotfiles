local ls = require 'luasnip'
local s = ls.s
local t = ls.t
local i = ls.i

ls.add_snippets('all', {
  -- documentation comment
  s('/**', { t { '/**', ' * ' }, i(0), t { '', ' */' } }, {
    show_condition = function(line_to_cursor) return line_to_cursor:find '^%s*/$' end,
  }),
})
