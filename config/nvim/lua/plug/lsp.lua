local mappings = require 'user.mappings'

------------------------------
--                          --
--          Format          --
--                          --
------------------------------
local format_aug = vim.api.nvim_create_augroup('LspAutoFormatting', {})
local function init_auto_formatting()
  local function is_enabled(scope)
    local val = vim[scope].auto_format_enabled
    if val == nil then return true end
    return val
  end
  local function toggle_enabled(scope)
    local bool = not is_enabled(scope)
    vim[scope].auto_format_enabled = bool
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
    return function()
      vim.lsp.buf.format {
        filter = function(client) return client.name == filter end,
      }
    end
  end
  if type(filter) == 'table' then
    return function()
      vim.lsp.buf.format {
        filter = function(client) return vim.tbl_contains(filter, client.name) end,
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
      if
        not vim.b.auto_hover_diagnostics_disabled
        and vim.lsp.buf.server_ready()
        and not is_another_hover_win_existing()
      then
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
    'nvimtools/none-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    { 'weilbith/nvim-code-action-menu', config = setup_code_action_menu },
    {
      'ray-x/lsp_signature.nvim',
      opts = { bind = true, hint_prefix = '▷  ' },
    },
    'jose-elias-alvarez/typescript.nvim',
    'b0o/SchemaStore.nvim',
    -- { 'folke/neodev.nvim', config = true },
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
    local nls = require 'null-ls'
    local nfn = nls.builtins
    local Lsp = {}
    local Fmt = {}
    local Diag = {}
    local Nls = setmetatable({}, { __index = table })

    --
    -- Lua
    -----------------------------
    -----------------------------
    -- require('neodev').setup {}
    Lsp.lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          runtime = 'LuaJIT',
          diagnostics = {
            globals = { 'vim', 'before_each', 'describe', 'it' },
          },
          library = vim.api.nvim_get_runtime_file('', true),
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
    }
    Nls:insert(nfn.formatting.stylua)
    Fmt.lua = create_fmt_fn 'null-ls'

    --
    -- JavaScript/TypeScript
    -----------------------------
    -----------------------------
    Lsp.tsserver = {
      root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
      single_file_support = false,
      -- on_attach = function(client)
      --   client.server_capabilities.documentFormattingProvider = false
      -- end,
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
    -- NOTE: Biome can be also used as a LSP server, but it requires
    --  dynamic registration of capabilities which is supported in
    --  Neovim 0.10.
    Lsp.biome = {}
    Nls:insert(nfn.formatting.biome)
    Lsp.eslint = {}
    Nls:insert(nfn.formatting.biome.with {
      condition = function(utils) return utils.root_has_file 'biome.json' end,
    })
    Nls:insert(nfn.formatting.prettierd.with {
      env = { PRETTIERD_DEFAULT_CONFIG = vim.env.PRETTIERD_DEFAULT_CONFIG },
      condition = function(utils)
        return not utils.root_has_file {
          'deno.json',
          'deno.jsonc',
          'biome.json',
        }
      end,
    })
    Fmt.javascript = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.typescript = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.javascriptreact = create_fmt_fn { 'null-ls', 'denols' }
    Fmt.typescriptreact = create_fmt_fn { 'null-ls', 'biome', 'denols' }
    Fmt.vue = create_fmt_fn { 'null-ls', 'denols' }
    Lsp.prismals = {}

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
    Nls:insert(nfn.diagnostics.stylelint.with {
      filter = function(diagnostic)
        return not vim.startswith(
          diagnostic.message,
          'Error: No configuration provided for '
        )
      end,
    })

    --
    -- Golang
    -----------------------------
    -----------------------------
    Lsp.gopls = {}
    Lsp.golangci_lint_ls = {}
    Fmt.go = function() require('go.format').goimport() end

    --
    -- C
    -----------------------------
    -----------------------------
    Lsp.clangd = {}

    --
    -- Shellscript
    -----------------------------
    -----------------------------
    Lsp.bashls = {}
    local group =
      vim.api.nvim_create_augroup('dotenv-vs-bashls', { clear = true })
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = { '.env', '.env.*' },
      group = group,
      callback = function(args)
        vim.b.auto_hover_diagnostics_disabled = true
        vim.diagnostic.disable(args.buf)
      end,
    })
    Nls:insert(nfn.diagnostics.zsh)

    --
    -- PHP
    -----------------------------
    -----------------------------
    Lsp.intelephense = {
      handlers = {
        ['textDocument/publishDiagnostics'] = function(...) end,
      },
    }
    Nls:insert(nfn.diagnostics.phpstan.with {
      only_local = 'vendor/bin',
      extra_args = { '--memory-limit=2G' },
    })
    Nls:insert(nfn.formatting.phpcsfixer.with {
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
          schemas = require('schemastore').json.schemas {},
          validate = { enable = true },
        },
      },
    }
    Fmt.json = create_fmt_fn 'null-ls'

    --
    -- YAML
    -----------------------------
    -----------------------------
    -- https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
    Lsp.yamlls = {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          schemas = require('schemastore').yaml.schemas(),
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
    Lsp.sqlls = {}
    Lsp.graphql = {}
    Lsp.grammarly = {}
    Nls:insert(nfn.code_actions.gitsigns)
    Nls:insert(nfn.diagnostics.cfn_lint)
    Nls:insert(nfn.diagnostics.actionlint)
    Nls:insert(nfn.diagnostics.editorconfig_checker.with {
      command = 'editorconfig-checker',
      extra_args = { '--exclude', 'node_modules' },
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
        Nls
      ),
    }

    ml.setup_handlers {
      function(server_name)
        local config = vim.tbl_deep_extend('force', {
          on_attach = on_attach,
          capabilities = cap,
        }, Lsp[server_name] or {})
        if server_name == 'tsserver' then
          return require('typescript').setup { server = config }
        end
        require('lspconfig')[server_name].setup(config)
      end,
    }
    nls.setup {
      sources = Nls,
      on_attach = on_attach,
    }
  end,
}
