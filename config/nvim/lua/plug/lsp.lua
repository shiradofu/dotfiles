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

local function create_custom_format_functions()
  local null_ls = function() vim.lsp.buf.format { name = 'null-ls' } end
  local prettier_or_deno =
    function() vim.lsp.buf.format { 'null-ls', 'denols' } end
  return {
    lua = null_ls,
    javascript = prettier_or_deno,
    typescript = prettier_or_deno,
    javascriptreact = prettier_or_deno,
    typescriptreact = prettier_or_deno,
    vue = prettier_or_deno,
    html = null_ls,
    css = null_ls,
    sass = null_ls,
    scss = null_ls,
    less = null_ls,
    php = null_ls,
    json = null_ls,
    go = function()
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
    end,
  }
end

-------------------------------
--                           --
--        Diagnostics        --
--                           --
-------------------------------

---Diagnostics の上にカーソルがあれば自動的に表示
---vim.lsp.buf.hover() が表示されている間は表示しない
local function init_auto_hover_diagnostics()
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

local function create_custom_diagnostics_configs()
  return {
    sh = function()
      local fname = vim.api.nvim_buf_get_name(0):match '[^/]*'
      if fname == '.env' or fname:find '%.env%..+' then
        vim.diagnostic.disable(0)
      end
    end,
  }
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
--        LSP Config        --
--                          --
------------------------------

local function create_on_attach()
  local attach_auto_formatting = init_auto_formatting()
  local custom_format_fns = create_custom_format_functions()
  local custom_diagnostics_configs = create_custom_diagnostics_configs()

  return function(_, bufnr)
    mappings.lsp_jump()
    mappings.lsp_hover()
    mappings.lsp_rename()
    mappings.lsp_action()

    local ft = vim.bo[bufnr].filetype

    local format_fn = custom_format_fns[ft] or vim.lsp.buf.format
    mappings.lsp_format(format_fn)
    attach_auto_formatting(bufnr, format_fn)

    local custom_diagnostics_config = custom_diagnostics_configs[ft]
    if custom_diagnostics_config then custom_diagnostics_config() end
  end
end

local function create_lspconfigs(on_attach)
  local base_config = { on_attach = on_attach }

  local root_pattern = require('lspconfig').util.root_pattern
  local M = {}

  M.sumneko_lua = vim.tbl_deep_extend('force', base_config, {
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
  })

  M.clangd = vim.deepcopy(base_config)
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
end

------------------------------
--                          --
--           Null           --
--                          --
------------------------------

local function setup_null_ls(on_attach)
  local null = require 'null-ls'
  local a = null.builtins.code_actions
  local f = null.builtins.formatting
  local d = null.builtins.diagnostics

  null.setup {
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

    local mason = require 'mason-lspconfig'
    local on_attach = create_on_attach()
    local lspconfigs = create_lspconfigs(on_attach)
    local cap = require('cmp_nvim_lsp').default_capabilities()
    mason.setup { ensure_installed = vim.tbl_keys(lspconfigs) }
    mason.setup_handlers {
      function(server_name)
        lspconfigs[server_name].capabilities = cap
        if server_name == 'sumneko_lua' then require('neodev').setup {} end
        if server_name == 'tsserver' then
          require('typescript').setup { server = lspconfigs[server_name] }
        else
          require('lspconfig')[server_name].setup(lspconfigs[server_name])
        end
      end,
    }
    setup_null_ls(on_attach)

    mappings.lsp_diagnostic()
    init_auto_hover_diagnostics()
    setup_lsp_float_border()

    -- local notify = vim.notify
    -- vim.notify = function(msg, ...)
    --   if msg:match 'warning: multiple different client offset_encodings' then
    --     return
    --   end
    --   notify(msg, ...)
    -- end
  end,
}
