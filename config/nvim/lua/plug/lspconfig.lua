local M = {}
local root_pattern = require('lspconfig').util.root_pattern
local mappings = require 'user.mappings'
local fmt = require 'plug.lsp-format'
local diagnostics = require 'plug.lsp-diagnostics'

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

mappings.lsp_diagnostic()

local function on_attach(client, bufnr)
  mappings.lsp_jump()
  mappings.lsp_hover()
  mappings.lsp_rename()
  mappings.lsp_action()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  fmt[fmt[ft] and ft or '_'](client, bufnr)
  diagnostics[diagnostics[ft] and ft or '_'](client, bufnr)
end

local base_config = {
  on_attach = on_attach,
  lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  },
}

M.sumneko_lua = vim.tbl_deep_extend('force', base_config, {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- runtime = 'LuaJIT',
      -- diagnostics = {
      --   globals = { 'vim', 'before_each', 'describe', 'it', 'packer_plugins' },
      -- },
      -- library = vim.api.nvim_get_runtime_file('', true),
      -- telemetry = {
      --   enable = false,
      -- },
    },
  },
})

M.ccls = vim.deepcopy(base_config)
M.gopls = vim.deepcopy(base_config)
M.golangci_lint_ls = vim.deepcopy(base_config)

M.tsserver = vim.tbl_deep_extend('force', base_config, {
  root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
})

M.denols = vim.tbl_deep_extend('force', base_config, {
  root_dir = root_pattern('deno.json', 'deno.jsonc'),
  single_file_support = false,
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

M.html = vim.deepcopy(base_config)
M.cssls = vim.deepcopy(base_config)
M.cssmodules_ls = vim.deepcopy(base_config)
M.intelephense = vim.tbl_deep_extend('force', base_config, {
  handlers = {
    ['textDocument/publishDiagnostics'] = function(...) end,
  },
})
M.tailwindcss = vim.deepcopy(base_config)
M.bashls = vim.deepcopy(base_config)
M.sqls = vim.deepcopy(base_config)
M.dockerls = vim.deepcopy(base_config)
M.yamlls = vim.deepcopy(base_config)

M.jsonls = vim.tbl_deep_extend('force', base_config, {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

M.vimls = vim.deepcopy(base_config)

return M
