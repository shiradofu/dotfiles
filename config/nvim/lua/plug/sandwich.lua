local M = {}
function M.setup() vim.g.sandwich_no_default_key_mappings = 1 end

function M.config()
  local recipes = {}
  vim.list_extend(recipes, vim.g['sandwich#default_recipes'])

  local abbr_recipes = {
    { input = { 'r' }, buns = { '(', ')' }, nesting = 1 },
    { input = { 'b' }, buns = { '{', '}' }, nesting = 1 },
    { input = { 's' }, buns = { '[', ']' }, nesting = 1 },
    { input = { 'a' }, buns = { '<', '>' }, nesting = 1 },
  }
  vim.list_extend(recipes, abbr_recipes)

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

return M
