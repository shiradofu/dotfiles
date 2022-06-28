local M = {}
local k = vim.keymap.set
local root_pattern = require'lspconfig'.util.root_pattern
local create_on_attach = require'user/lsp-attach'
local WAIT_MS = 1000

local o = { noremap = true, silent = true }
k('n', '[e', vim.diagnostic.goto_prev, o)
k('n', ']e', vim.diagnostic.goto_next, o)


local basic_on_attach = create_on_attach()

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

M.sumneko_lua = {
  on_attach = create_on_attach({
    -- use stylua
    fmt_off = true,
    fmt_fn = function(opt)
      vim.lsp.buf.formatting_sync(opt, WAIT_MS)
    end,
  }),
  lsp_flags = lsp_flags,
  settings = {
    Lua = {
      runtime = 'LuaJIT',
      diagnostics = {
        globals = { 'vim' }
      },
      library = vim.api.nvim_get_runtime_file('', true),
      telemetry = {
        enable = false,
      },
    },
  },
}

M.ccls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.gopls = {
  on_attach = create_on_attach({
    fmt_fn = function(opt)
      vim.lsp.buf.formatting_sync(opt)
      -- goimports on save
      -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
      local params = vim.lsp.util.make_range_params()
      params.context = {only = {"source.organizeImports"}}
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, WAIT_MS)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end
  }),
  lsp_flags = lsp_flags,
}

M.golangci_lint_ls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.tsserver = {
  root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  on_attach = create_on_attach({
    -- use prettier
    fmt_off = true,
    fmt_fn = function(opt)
      vim.lsp.buf.formatting_sync(opt, WAIT_MS)
    end,
  }),
  lsp_flags = lsp_flags,
}

M.denols = {
  root_dir = root_pattern("deno.json", "deno.jsonc"),
  init_options = {
    lint = true,
    unstable = false,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
        },
      },
    },
  },
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.cssls = {
  -- doesn't support format
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.cssmodules_ls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.html = {
  on_attach = create_on_attach({
    -- use prettier
    fmt_off = true,
    fmt_fn = function(opt)
      vim.lsp.buf.formatting_sync(opt, WAIT_MS)
    end,
  }),
  lsp_flags = lsp_flags,
}

M.intelephense = {
  on_attach = create_on_attach({
    fmt_fn = function(opt)
      vim.lsp.buf.formatting_seq_sync(opt, WAIT_MS, { 'intelephense', 'null-ls' })
    end,
  }),
  lsp_flags = lsp_flags,
}

M.bashls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.sqls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.dockerls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.yamlls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.jsonls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

M.vimls = {
  on_attach = basic_on_attach,
  lsp_flags = lsp_flags,
}

return M
