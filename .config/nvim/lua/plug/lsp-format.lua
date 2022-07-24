local M = {} -- keys are filetypes
local map = require('user/lsp-keymap').format
local t = require('user/utils').table
local WAIT_MS = 1000

vim.g.enable_auto_format = true
vim.api.nvim_create_user_command('AutoFormatToggle', function()
  vim.g.enable_auto_format = not vim.g.enable_auto_format
  local state = vim.g.enable_auto_format and 'enabled' or 'disabled'
  print('Auto formatting ' .. state)
end, { nargs = 0 })

local fmt_group = vim.api.nvim_create_augroup('LspFormatting', {})

local function create_fn(bufnr, servers)
  return function()
    vim.lsp.buf.formatting_seq_sync({ bufnr = bufnr }, WAIT_MS, servers)
  end
end

local function clear_au(bufnr)
  vim.api.nvim_clear_autocmds { group = fmt_group, buffer = bufnr }
end

local function create_au(bufnr, fn, config)
  config = config or {}
  vim.api.nvim_create_autocmd(
    'BufWritePre',
    t.merge({
      group = fmt_group,
      buffer = bufnr,
      callback = function()
        if vim.g.enable_auto_format then
          fn { bufnr = bufnr }
        end
      end,
    }, config)
  )
end

local function basic(_, bufnr)
  local fn = vim.lsp.buf.formatting_sync
  map(fn)
  clear_au(bufnr)
  create_au(bufnr, fn)
end

local function null_only(client, bufnr)
  if client.name ~= 'null-ls' then
    client.resolved_capabilities.document_formatting = false
    return
  end
  basic(client, bufnr)
end

-- fallback
M._ = basic

M.lua = null_only
M.c = basic
M.cpp = basic
M.go = function(_, bufnr)
  local function fn()
    -- goimports on save
    -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result =
      vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, WAIT_MS)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
  map(fn)
  clear_au(bufnr)
  create_au(bufnr, fn)
end

local function prettier_or_deno(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
    return
  end
  local fmt_fn = create_fn(bufnr, { 'null-ls', 'denols' })
  local function fn()
    require('typescript').actions.organizeImports { sync = true }
    fmt_fn()
  end
  map(fn)
  clear_au(bufnr)
  create_au(bufnr, fn)
end

M.javascript = prettier_or_deno
M.typescript = prettier_or_deno
M.javascriptreact = prettier_or_deno
M.typescriptreact = prettier_or_deno
M.vue = prettier_or_deno
M.html = null_only
M.css = null_only
M.sass = null_only
M.scss = null_only
M.less = null_only
M.php = null_only
M.sh = basic
M.zsh = basic
M.sql = basic
M.docker = basic
M.yaml = basic
M.json = null_only
M.vim = basic

return M
