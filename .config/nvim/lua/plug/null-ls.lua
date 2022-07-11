local n = require "null-ls"
local a = n.builtins.code_actions
local f = n.builtins.formatting
local d = n.builtins.diagnostics
local fmt = require "plug.lsp-format"
local map = require "user/lsp-keymap"

map.diagnostic()

local function on_attach(client, bufnr)
  map.hover()
  map.action()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  fmt[fmt[ft] and ft or "_"](client, bufnr)
end

n.setup {
  sources = {
    a.gitsigns,
    f.stylua,
    a.eslint_d,
    d.eslint_d,
    f.prettierd.with {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "graphql",
        "handlebars",
      },
      condition = function(utils)
        return not utils.has_file { "deno.json", "deno.jsonc" }
      end,
    },
    d.stylelint,
    d.phpstan.with {
      only_local = "vendor/bin",
      extra_args = { "--memory-limit=2G" },
    },
    f.phpcsfixer.with {
      only_local = "vendor/bin",
    },
    d.zsh,
    d.cfn_lint,
    d.actionlint,
    d.editorconfig_checker.with {
      command = "editorconfig-checker",
    },
  },
  on_attach = on_attach,
}
