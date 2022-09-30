local ls = require 'luasnip'
local s = ls.s
local t = ls.t
local i = ls.i

ls.add_snippets('all', {
  -- documentation comment
  s('/**', { t { '/**', ' * ' }, i(0), t { '', ' */' } }),
})
