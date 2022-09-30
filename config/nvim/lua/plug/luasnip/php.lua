local ls = require 'luasnip'
local s = ls.s
local t = ls.t

ls.add_snippets('php', {
  s('this', t '$this'),
  s('this-', t '$this->'),
})
