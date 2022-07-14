local M = {}
local root_pattern = require('lspconfig').util.root_pattern
local map = require 'user/lsp-keymap'
local fmt = require 'plug.lsp-format'
local t = require('user/utils').table

local border = {
  { '┌', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '┐', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '┘', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '└', 'FloatBorder' },
  { '│', 'FloatBorder' },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

map.diagnostic()

local function on_attach(client, bufnr)
  map.jump()
  map.hover()
  map.rename()
  map.action()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  fmt[fmt[ft] and ft or '_'](client, bufnr)
end

local base_config = {
  on_attach = on_attach,
  lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  },
}

M.sumneko_lua = t.merge(base_config, {
  settings = {
    Lua = {
      runtime = 'LuaJIT',
      diagnostics = {
        globals = { 'vim' },
      },
      library = vim.api.nvim_get_runtime_file('', true),
      telemetry = {
        enable = false,
      },
    },
  },
})

M.ccls = t.copy(base_config)
M.gopls = t.copy(base_config)
M.golangci_lint_ls = t.copy(base_config)

M.tsserver = t.merge(base_config, {
  root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
})

M.denols = t.merge(base_config, {
  root_dir = root_pattern('deno.json', 'deno.jsonc'),
  init_options = {
    lint = true,
    unstable = false,
    suggest = {
      imports = {
        hosts = {
          ['https://deno.land'] = true,
        },
      },
    },
  },
})

M.html = t.copy(base_config)
M.cssls = t.copy(base_config)
M.cssmodules_ls = t.copy(base_config)
M.intelephense = t.merge(base_config, {
  handlers = {
    ['textDocument/publishDiagnostics'] = function(...) end,
  },
})
M.bashls = t.copy(base_config)
M.sqls = t.copy(base_config)
M.dockerls = t.copy(base_config)
M.yamlls = t.copy(base_config)

M.jsonls = t.merge(base_config, {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

M.vimls = t.copy(base_config)

return M
