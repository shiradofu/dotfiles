local mappings = require 'user.mappings'

------------------------------
--                          --
--          Format          --
--                          --
------------------------------
local format_aug = vim.api.nvim_create_augroup('LspAutoFormatting', {})
local function init_auto_formatting()
  local function is_enabled(scope)
    local val = vim[scope].enable_auto_format
    if val == nil then return true end
    return val
  end
  local function toggle_enabled(scope)
    local bool = not is_enabled(scope)
    vim[scope].enable_auto_format = bool
    return bool
  end
  vim.api.nvim_create_user_command(
    'AutoFormatToggleGlobal',
    function()
      print(
        '(Global) Auto formatting '
          .. (toggle_enabled 'g' and 'enabled' or 'disabled')
      )
    end,
    { nargs = 0 }
  )
  -- vim.api.nvim_create_user_command('AutoFormatToggleBuf', function()
  --   print(
  --     '(Buffer) Auto formatting '
  --       .. (toggle_enabled 'b' and 'enabled' or 'disabled')
  --   )
  -- end, { nargs = 0 })

  -- attach auto-formatting to bufnr
  return function(bufnr, format_fn)
    vim.api.nvim_clear_autocmds { group = format_aug, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = format_aug,
      buffer = bufnr,
      callback = function()
        if is_enabled 'g' and is_enabled 'b' then format_fn() end
      end,
    })
  end
end

local function create_fmt_fn(filter)
  if type(filter) == 'string' then
    return function() vim.lsp.buf.format { name = filter } end
  end
  if type(filter) == 'table' then
    return function()
      vim.lsp.buf.format {
        filter = function(client) return vim.tbl_contains(client, filter) end,
      }
    end
  end
  return function() vim.lsp.buf.format() end
end

-------------------------------
--                           --
--        Diagnostics        --
--                           --
-------------------------------
local function init_auto_hover_diagnostics()
  ---Diagnostics の上にカーソルがあれば自動的に表示
  ---vim.lsp.buf.hover() が表示されている間は表示しない
  local function is_another_hover_win_existing()
    local ok, winnr = pcall(vim.api.nvim_buf_get_var, 0, 'lsp_floating_preview')
    return ok and vim.api.nvim_win_is_valid(winnr)
  end

  local g = vim.api.nvim_create_augroup('MyDiagnostics', {})
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    group = g,
    callback = function()
      if vim.lsp.buf.server_ready() and not is_another_hover_win_existing() then
        vim.diagnostic.open_float()
      end
    end,
  })
end

-------------------------------
--                           --
--        Code Action        --
--                           --
-------------------------------
local function setup_code_action_menu()
  local c = require 'code_action_menu'

  -- overwrite builtin function
  vim.lsp.buf.code_action = c.open_code_action_menu

  local g = vim.api.nvim_create_augroup('MyCodeActionMenu', {})
  vim.api.nvim_clear_autocmds { group = g }
  vim.api.nvim_create_autocmd('Filetype', {
    pattern = 'code-action-menu-menu',
    group = g,
    callback = function()
      vim.keymap.set(
        'n',
        '<BS>',
        c.close_code_action_menu,
        { noremap = true, silent = true, buffer = true }
      )
      vim.keymap.set(
        'n',
        '<C-c>',
        c.close_code_action_menu,
        { noremap = true, silent = true, buffer = true }
      )
    end,
  })
end

------------------------------
--                          --
--           Misc           --
--                          --
------------------------------
local function setup_lsp_float_border()
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

  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig(contents, syntax, opts, ...)
  end

  vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Pmenu' })
end

------------------------------
--                          --
--           Main           --
--                          --
------------------------------
return {
  'williamboman/mason.nvim',
  event = 'VeryLazy',
  dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason-lspconfig.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    { 'weilbith/nvim-code-action-menu', config = setup_code_action_menu },
    {
      'ray-x/lsp_signature.nvim',
      opts = { bind = true, hint_prefix = '▷  ' },
    },
    'jose-elias-alvarez/typescript.nvim',
    'b0o/SchemaStore.nvim',
    { 'folke/neodev.nvim', config = true },
  },
  config = function()
    require('mason').setup {
      ui = {
        border = 'rounded',
        icons = {
          server_installed = '✓',
          server_pending = '◎',
          server_uninstalled = '-',
        },
      },
    }

    local root_pattern = require('lspconfig').util.root_pattern
    local null = require 'null-ls'
    local null_fn = null.builtins
    local Lsp = {}
    local Fmt = {}
    local Diag = {}
    local Null = {}
    setmetatable(Null, {
      __call = function(tbl, source) table.insert(tbl, source) end,
    })

    --
    -- Lua
    -----------------------------
    -----------------------------
    require('neodev').setup {}
    Lsp.sumneko_lua = {
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          runtime = 'LuaJIT',
          diagnostics = {
            globals = { 'vim', 'before_each', 'describe', 'it' },
          },
          library = vim.api.nvim_get_runtime_file('', true),
          telemetry = { enable = false },
        },
      },
    }
    Null(null_fn.formatting.stylua)
    Fmt.lua = create_fmt_fn 'null-ls'

    --
    -- JavaScript/TypeScript
    -----------------------------
    -----------------------------
    Lsp.tsserver = {
      root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
    }
    Lsp.denols = {
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
    }
    Null(null_fn.code_actions.eslint_d)
    Null(null_fn.diagnostics.eslint_d.with {
      filter = function(d)
        return not vim.startswith(
          d.message,
          'Error: No ESLint configuration found '
        )
      end,
    })
    Null(null_fn.formatting.prettierd.with {
      env = { PRETTIERD_DEFAULT_CONFIG = vim.env.PRETTIERD_DEFAULT_CONFIG },
      condition = function(utils)
        return not utils.has_file { 'deno.json', 'deno.jsonc' }
      end,
    })
    Fmt.javascript = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.typescript = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.javascriptreact = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.typescriptreact = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.vue = create_fmt_fn { 'null-ls', 'denols' }

    --
    -- HTML/CSS
    -----------------------------
    -----------------------------
    Lsp.html = {}
    Lsp.cssls = {}
    Lsp.cssmodules_ls = {}
    Lsp.tailwindcss = {}
    Fmt.html = create_fmt_fn 'null-ls'
    Fmt.css = create_fmt_fn 'null-ls'
    Fmt.sass = create_fmt_fn 'null-ls'
    Fmt.scss = create_fmt_fn 'null-ls'
    Fmt.less = create_fmt_fn 'null-ls'
    Null(null_fn.diagnostics.stylelint)

    --
    -- Golang
    -----------------------------
    -----------------------------
    Lsp.gopls = {}
    Lsp.golangci_lint_ls = {}
    Fmt.go = function()
      -- goimports on save
      -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { 'source.organizeImports' } }
      local result =
        ---@diagnostic disable-next-line: missing-parameter
        vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
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

    --
    -- C
    -----------------------------
    -----------------------------
    Lsp.clangd = {}

    --
    -- Shellscript
    -----------------------------
    -----------------------------
    Lsp.bashls = {
      handlers = {
        ['textDocument/publishDiagnostics'] = function(...) end,
      },
    }
    Null(null_fn.diagnostics.shellcheck.with {
      -- shellcheck with mason.nvim doesn't support Apple Silicon
      command = vim.env.HOMEBREW_PREFIX .. '/bin/shellcheck',
      runtime_condition = function()
        local fname = vim.api.nvim_buf_get_name(0)
        return not (fname == '.env' or fname:find '%.env%..+')
      end,
    })
    Null(null_fn.diagnostics.zsh)

    --
    -- PHP
    -----------------------------
    -----------------------------
    Lsp.intelephense = {
      handlers = {
        ['textDocument/publishDiagnostics'] = function(...) end,
      },
    }
    Null(null_fn.diagnostics.phpstan.with {
      only_local = 'vendor/bin',
      extra_args = { '--memory-limit=2G' },
    })
    Null(null_fn.formatting.phpcsfixer.with {
      only_local = 'vendor/bin',
    })
    Fmt.php = create_fmt_fn 'null-ls'

    --
    -- JSON
    -----------------------------
    -----------------------------
    Lsp.jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }
    Fmt.json = create_fmt_fn 'null-ls'

    --
    -- Others
    -----------------------------
    -----------------------------
    Lsp.vimls = {}
    Lsp.dockerls = {}
    Lsp.yamlls = {}
    Lsp.sqlls = {}
    Lsp.graphql = {}
    Lsp.grammarly = {}
    Null(null_fn.code_actions.gitsigns)
    Null(null_fn.diagnostics.cfn_lint)
    Null(null_fn.diagnostics.actionlint)
    Null(null_fn.diagnostics.editorconfig_checker.with {
      command = 'editorconfig-checker',
    })

    mappings.lsp_diagnostic()
    init_auto_hover_diagnostics()
    setup_lsp_float_border()
    local attach_auto_formatting = init_auto_formatting()

    local function on_attach(_, bufnr)
      mappings.lsp_jump()
      mappings.lsp_hover()
      mappings.lsp_rename()
      mappings.lsp_action()
      local ft = vim.bo[bufnr].filetype
      local format_fn = Fmt[ft] or vim.lsp.buf.format
      mappings.lsp_format(format_fn)
      attach_auto_formatting(bufnr, format_fn)
      local diag_config = Diag[ft]
      if diag_config then diag_config() end
    end

    local cap = require('cmp_nvim_lsp').default_capabilities()

    local ml = require 'mason-lspconfig'
    local mn = require 'mason-null-ls'
    ml.setup { ensure_installed = vim.tbl_keys(Lsp) }
    mn.setup {
      ensure_installed = vim.tbl_map(
        function(source) return source.name end,
        Null
      ),
    }

    ml.setup_handlers {
      function(server_name)
        local config = vim.tbl_deep_extend('force', {
          on_attach = on_attach,
          capabilities = cap,
        }, Lsp[server_name])
        if server_name == 'tsserver' then
          return require('typescript').setup { server = config }
        end
        require('lspconfig')[server_name].setup(config)
      end,
    }
    null.setup {
      sources = Null,
      on_attach = on_attach,
    }
  end,
}
