local n = require 'null-ls'
local a = n.builtins.code_actions
local f = n.builtins.formatting
local d = n.builtins.diagnostics
local fmt = require 'plug.lsp-format'
local mappings = require 'user.mappings'

mappings.lsp_diagnostic()

local function on_attach(client, bufnr)
  mappings.lsp_hover()
  mappings.lsp_action()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  fmt[fmt[ft] and ft or '_'](client, bufnr)
end

n.setup {
  sources = {
    a.gitsigns,
    f.stylua,
    a.eslint_d,
    d.eslint_d.with {
      filter = function(diagnostic)
        if
          vim.startswith(
            diagnostic.message,
            'Error: No ESLint configuration found in '
          )
        then
          return false
        end
        return true
      end,
    },
    f.prettierd.with {
      env = {
        PRETTIERD_DEFAULT_CONFIG = vim.env.PRETTIERD_DEFAULT_CONFIG,
      },
      condition = function(utils)
        return not utils.has_file { 'deno.json', 'deno.jsonc' }
      end,
    },
    d.stylelint,
    d.phpstan.with {
      only_local = 'vendor/bin',
      extra_args = { '--memory-limit=2G' },
    },
    f.phpcsfixer.with {
      only_local = 'vendor/bin',
    },
    d.zsh,
    d.cfn_lint,
    d.actionlint,
    d.editorconfig_checker.with {
      command = 'editorconfig-checker',
    },
  },
  on_attach = on_attach,
}
