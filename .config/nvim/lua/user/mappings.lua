local req = require('user.utils').fn.req
local function k(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end
local r = { remap = true }
local b = { buffer = true }
local e = { expr = true }

local M = {}

function M.tab_move()
  k('n', '<C-n>', 'gt')
  k('n', '<C-p>', 'gT')
end
M.tab_move()

function M.win_move()
  k('n', '<C-h>', '<C-w>h')
  k('n', '<C-j>', '<C-w>j')
  k('n', '<C-k>', '<C-w>k')
  k('n', '<C-l>', '<C-w>l')
end
M.win_move()

function M.win_resize()
  k('n', '<C-w><C-h>', "<Cmd>call user#win#resize('h')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-j>', "<Cmd>call user#win#resize('j')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-k>', "<Cmd>call user#win#resize('k')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-l>', "<Cmd>call user#win#resize('l')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-h>', "<Cmd>call user#win#resize('h')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-j>', "<Cmd>call user#win#resize('j')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-k>', "<Cmd>call user#win#resize('k')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-l>', "<Cmd>call user#win#resize('l')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)', '<Nop>', r)
end
M.win_resize()

function M.lsp_diagnostic()
  k('n', '[e', vim.diagnostic.goto_prev)
  k('n', ']e', vim.diagnostic.goto_next)
end
function M.lsp_jump()
  k('n', 'gd', vim.lsp.buf.definition, b)
  k('n', 'gD', '<cmd>vs|lua vim.lsp.buf.definition()<CR>', b)
  k('n', '<leader>n', vim.lsp.buf.references, b)
end
function M.lsp_hover()
  k('n', 'K', vim.lsp.buf.hover, b)
end
function M.lsp_rename()
  k('n', 'gr', vim.lsp.buf.rename, b)
end
function M.lsp_action()
  k('n', 'ga', vim.lsp.buf.code_action, b)
end
function M.lsp_format(fn)
  k('n', '=', fn, b)
end

function M.luasnip()
  local mod = 'luasnip'
  k({ 'i', 's' }, '<C-j>', req(mod, 'jump', 1))
  k({ 'i', 's' }, '<C-k>', req(mod, 'jump', -1))
end

function M.cmp_selection(cmp)
  return {
    ['<Tab>'] = cmp.mapping.confirm { select = true },
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_next_item()
        else
          cmp.select_prev_item()
        end
      else
        fallback()
      end
    end,
    ['<C-p>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_prev_item()
        else
          cmp.select_next_item()
        end
      else
        fallback()
      end
    end,
    ['<C-l>'] = cmp.mapping.abort(),
  }
end

function M.textcase()
  local mod = 'textcase'
  k('n', 'gc', '<Nop>')
  for mode, fn in pairs { n = 'operator', x = 'visual' } do
    k(mode, 'gcu', req(mod, fn, 'to_upper_case'))
    k(mode, 'gcl', req(mod, fn, 'to_lower_case'))
    k(mode, 'gcc', req(mod, fn, 'to_camel_case'))
    k(mode, 'gcs', req(mod, fn, 'to_snake_case'))
    k(mode, 'gck', req(mod, fn, 'to_dash_case'))
    k(mode, 'gcn', req(mod, fn, 'to_constant_case'))
    k(mode, 'gcd', req(mod, fn, 'to_dot_case'))
    k(mode, 'gcp', req(mod, fn, 'to_pascal_case'))
  end
end
M.textcase()

return M
