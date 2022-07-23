local npairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'

npairs.setup {
  map_cr = false,
  map_c_h = true,
  map_c_w = true,
  enable_bracket_in_quote = false,
}

local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

local ok, cmp = pcall(require, 'cmp')
if ok then
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

local parenRule = npairs.get_rule '('
local braceRule = npairs.get_rule '{'
local bracketRule = npairs.get_rule '['
npairs.add_rules {
  -- plug#autopairs#(comma|semi)() のための準備
  parenRule:with_cr(function()
    vim.b.bracket_cr_done = true
    return true
  end),
  braceRule:with_cr(function()
    vim.b.bracket_cr_done = true
    return true
  end),
  bracketRule:with_cr(function()
    vim.b.bracket_cr_done = true
    return true
  end),
  -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
  Rule(' ', ' '):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({ '()', '[]', '{}' }, pair)
  end),
  Rule('( ', ' )')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%)' ~= nil
    end)
    :use_key ')',
  Rule('{ ', ' }')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%}' ~= nil
    end)
    :use_key '}',
  Rule('[ ', ' ]', '-markdown')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%]' ~= nil
    end)
    :use_key ']',
}

local group_oc = vim.api.nvim_create_augroup('AutoPairsObserveComma', {})
local function observe_after_cr_done(bufnr)
  vim.api.nvim_clear_autocmds { group = group_oc, buffer = bufnr }
  vim.api.nvim_create_autocmd({
    'InsertLeave',
    'TextChangedI',
    'CursorMovedI',
  }, {
    callback = function()
      vim.b.bracket_cr_done = false
      vim.api.nvim_clear_autocmds { group = group_oc, buffer = bufnr }
    end,
    group = group_oc,
    buffer = bufnr,
  })
end

local group_cd = vim.api.nvim_create_augroup('AutoPairsCrDone', {})
vim.api.nvim_clear_autocmds { group = group_cd, buffer = vim.fn.bufnr() }
vim.api.nvim_create_autocmd('TextChangedI', {
  callback = function()
    if vim.b.bracket_cr_done then
      observe_after_cr_done(vim.fn.bufnr())
    end
  end,
  group = group_cd,
})
