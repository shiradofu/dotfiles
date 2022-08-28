local ls = require 'luasnip'
local s = ls.s
local t = ls.t

ls.add_snippets('sh', {
  s('n', t '>/dev/null'),
  s('nn', t '>/dev/null 2>&1'),
})
