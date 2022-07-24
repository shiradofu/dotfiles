local ls = require 'luasnip'
local utils = require 'plug.luasnip.utils'

local s = ls.s
local t = ls.t

ls.add_snippets('json', {
  s(
    '_prettier_config',
    t {
      '"prettier": {',
      '  "tabWidth": 2,',
      '  "semi": false,',
      '  "singleQuote": true,',
      '  "trailingComma": "es5"',
      '}',
    },
    utils.show_only_when_buf_matching '/package.json$'
  ),
  s(
    '_prettier_script',
    t [["fmt": "prettier --write './**/*.{js,jsx,ts,tsx,json}'"]],
    utils.show_only_when_buf_matching '/package.json$'
  ),
})
