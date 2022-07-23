local ls = require 'luasnip'

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
    }
  ),
  s(
    '_prettier_script',
    t [["fmt": "prettier --write './**/*.{js,jsx,ts,tsx,json}'"]]
  ),
})
