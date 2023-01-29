return function()
  vim.g.sandwich_no_default_key_mappings = 1

  local recipes = {}
  vim.list_extend(recipes, vim.g['sandwich#default_recipes'])

  -- スペースを含むレシピ
  vim.list_extend(recipes, {
    {
      buns = { '{ ', ' }' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '{' },
    },
    {
      buns = { '[ ', ' ]' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '[' },
    },
    {
      buns = { '( ', ' )' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '(' },
    },
    {
      buns = { [[{\s*]], [[\s*}]] },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '{' },
    },
    {
      buns = { [=[\[\s*]=], [=[\s*\]]=] },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '[' },
    },
    {
      buns = { [[(\s*]], [[\s*)]] },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '(' },
    },
  })

  vim.g['sandwich#recipes'] = recipes
end
