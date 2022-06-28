local n = require'null-ls'
local a = n.builtins.code_actions
local f = n.builtins.formatting
local d = n.builtins.diagnostics

local create_on_attach = require'user/lsp-attach'

n.setup{
  sources = {
    -- a.gitsigns,
    f.stylua,
    a.eslint_d,
    d.eslint_d,
    f.prettierd.with {
      condition = function(utils)
        return not utils.has_file {"deno.json", "deno.jsonc"}
      end,
    },
    d.stylelint,
    d.phpstan.with({
      only_local = 'vendor/bin',
      extra_args = { '--memory-limit=2G' },
    }),
    f.phpcsfixer.with({
      only_local = 'vendor/bin',
    }),
    a.shellcheck,
    d.shellcheck,
    d.zsh,
    d.cfn_lint,
    d.actionlint,
    d.editorconfig_checker.with({
      command = 'editorconfig-checker',
    }),
  },
  on_attach = create_on_attach(),
}
