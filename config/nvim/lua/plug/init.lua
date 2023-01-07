vim.cmd [[packadd packer.nvim]]
require 'plug.packer'

local packer = require 'packer'
local util = require 'user.util'
packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -------------------------------------------------------------
  -- Library

  use 'nvim-lua/plenary.nvim' -- do not lazy load
  use { 'tpope/vim-repeat', opt = true }
  use {
    'kyazdani42/nvim-web-devicons',
    module = 'nvim-web-devicons',
  }

  --------------------------------------------------------------
  -- Fundamental

  use {
    'lambdalisue/fern.vim',
    requires = 'antoinemadec/FixCursorHold.nvim',
    branch = 'main',
    setup = function() require 'plug.fern' end,
  }
  use 'lambdalisue/fern-hijack.vim'
  use 'lewis6991/impatient.nvim'
  use {
    'nathom/filetype.nvim',
    config = function() require 'plug.filetype' end,
  }

  --------------------------------------------------------------
  -- Treesitter & Text Objects

  --------------------------------
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require 'plug.treesitter' end,
    cmd = { 'TSUpdate', 'TSUpdateSync' },
  }
  use {
    'yioneko/nvim-yati', -- improve indentation
    requires = 'nvim-treesitter/nvim-treesitter',
    event = 'ModeChanged',
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter',
    event = 'ModeChanged',
  }
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      { 'tpope/vim-commentary', event = 'ModeChanged' },
    },
    event = 'ModeChanged',
  }
  use {
    'nvim-treesitter/playground',
    requires = 'nvim-treesitter/nvim-treesitter',
    cmd = {
      'TSPlaygroundToggle',
      'TSHighlightCapturesUnderCursor',
    },
    module = 'user.newline',
  }

  --------------------------------
  -- Text Objects and Operators
  use {
    'kana/vim-textobj-user',
    config = function() vim.fn['plug#textobj#config']() end,
    opt = true,
  }
  use { 'sgur/vim-textobj-parameter', event = 'ModeChanged' }
  use { 'kana/vim-textobj-entire', event = 'ModeChanged' }
  use { 'kana/vim-textobj-indent', event = 'ModeChanged' }
  use { 'kana/vim-textobj-line', event = 'ModeChanged' }
  use { 'glts/vim-textobj-comment', event = 'ModeChanged' }
  use {
    'machakann/vim-sandwich',
    setup = function() vim.fn['plug#sandwich#setup']() end,
    keys = '<Plug>(sandwich-',
  }
  use {
    'gbprod/substitute.nvim',
    config = function() require('substitute').setup {} end,
    opt = true,
  }

  --------------------------------------------------------------
  -- Language & Completion

  --------------------------------
  -- Language Server Protocol(LSP)
  use {
    'neovim/nvim-lspconfig',
    config = function() require 'plug.lspconfig' end,
    opt = true,
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function() require 'plug.null-ls' end,
    opt = true,
  }
  use { 'jose-elias-alvarez/typescript.nvim', opt = true }
  use { 'b0o/SchemaStore.nvim', opt = true }
  use { 'gennaro-tedesco/nvim-jqx', opt = true }
  use {
    'ray-x/go.nvim',
    ft = 'go',
    config = function() require('go').setup() end,
  }
  use {
    'williamboman/nvim-lsp-installer',
    config = function() require 'plug.lsp-installer' end,
    cmd = 'LspInstall',
  }
  use {
    'ray-x/lsp_signature.nvim',
    config = function() require 'plug.lsp-signature' end,
    opt = true,
  }

  --------------------------------
  -- Filetype
  use {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end,
    requires = 'nvim-treesitter/nvim-treesitter',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'vue', 'xml' },
  }
  use {
    'plasticboy/vim-markdown',
    setup = function() vim.fn['plug#markdown#setup']() end,
    ft = 'markdown',
  }
  use {
    'jkramer/vim-checkbox',
    setup = function() vim.fn['plug#checkbox#setup']() end,
    ft = 'markdown',
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown',
    keys = '<Plug>MarkdownPreviewToggle',
    cmd = 'MarkdownPreviewToggle',
  }
  use {
    'RRethy/nvim-treesitter-endwise',
    requires = 'nvim-treesitter/nvim-treesitter',
    ft = { 'ruby', 'lua', 'vim', 'sh', 'zsh' },
  }
  use {
    'Decodetalkers/csv-tools.lua',
    ft = 'csv',
  }

  --------------------------------
  -- Completion
  local cmp_e = { 'InsertEnter', 'CmdlineEnter' }
  use {
    'hrsh7th/nvim-cmp',
    config = function() require 'plug.cmp' end,
    requires = 'L3MON4D3/LuaSnip',
    after = 'LuaSnip',
    module = 'cmp',
  }
  use { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }
  use { 'hrsh7th/cmp-buffer', event = cmp_e }
  use { 'hrsh7th/cmp-path', event = cmp_e }
  use { 'hrsh7th/cmp-cmdline', event = cmp_e }
  use { 'saadparwaiz1/cmp_luasnip', event = cmp_e }
  use { 'lukas-reineke/cmp-rg', event = cmp_e }
  use { 'davidsierradz/cmp-conventionalcommits', event = cmp_e }
  use { 'hrsh7th/cmp-nvim-lua', event = cmp_e }

  --------------------------------
  -- Snippet
  use {
    'L3MON4D3/LuaSnip',
    config = function() require 'plug.luasnip' end,
    module = 'luasnip',
  }

  --------------------------------
  -- Other Features
  use {
    'weilbith/nvim-code-action-menu',
    config = function() require 'plug.code-action-menu' end,
    opt = true,
  }
  use { 'gpanders/editorconfig.nvim', opt = true }

  --------------------------------------------------------------
  -- Testing and Debugging

  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function() require 'plug.neotest' end,
    module = 'neotest',
  }
  use { 'haydenmeade/neotest-jest', ft = util.js_family }
  use { 'KaiSpencer/neotest-vitest', ft = util.js_family }
  use { 'olimorris/neotest-phpunit', ft = 'php' }
  use { 'nvim-neotest/neotest-go', ft = 'go' }

  --------------------------------------------------------------
  -- Fuzzy Finder

  use {
    'ibhagwan/fzf-lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require 'plug.fzf' end,
  }

  --------------------------------------------------------------
  -- Git

  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require 'plug.diffview' end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plug.gitsigns' end,
    opt = true,
  }
  use {
    'akinsho/git-conflict.nvim',
    config = function() require('git-conflict').setup() end,
    opt = true,
  }
  use {
    'samoshkin/vim-mergetool',
    setup = function()
      vim.g.mergetool_layout = 'LmR'
      vim.g.mergetool_prefer_revision = 'base'
    end,
    opt = true,
  }
  use {
    'tyru/open-browser-github.vim',
    requires = 'open-browser.vim',
    after = 'open-browser.vim',
    cmd = 'OpenGithubFile',
  }

  --------------------------------------------------------------
  -- Editing

  --------------------------------
  -- Inside buffer
  use {
    'haya14busa/vim-asterisk',
    keys = '<Plug>(asterisk-',
    setup = function() vim.g['asterisk#keeppos'] = 1 end,
  }
  use {
    'kevinhwang91/nvim-hlslens',
    config = function() require 'plug.hlslens' end,
    opt = true,
  }
  use {
    'petertriho/nvim-scrollbar',
    config = function() require('scrollbar').setup {} end,
    module = 'scrollbar.handlers.search',
  }
  use {
    'shiradofu/nice-scroll.nvim',
    config = function() require('nice-scroll').setup {} end,
    requires = 'kevinhwang91/nvim-hlslens',
    after = 'nvim-hlslens',
    module = 'nice-scroll',
  }
  use {
    'rhysd/clever-f.vim',
    setup = function() vim.fn['plug#clever_f#setup']() end,
    keys = { '<Plug>(clever-f-' },
  }
  use {
    'rlane/pounce.nvim',
    config = function() require 'plug.pounce' end,
    cmd = 'Pounce',
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
    opt = true,
  }
  use {
    't9md/vim-quickhl',
    keys = '<Plug>(quickhl-',
  }
  use {
    'ntpeters/vim-better-whitespace',
    setup = function() vim.fn['plug#whitespace#setup']() end,
    opt = true,
  }
  use {
    'windwp/nvim-autopairs',
    config = function() require 'plug.autopairs' end,
    event = 'InsertEnter',
  }
  use {
    'johmsalas/text-case.nvim',
    module = 'textcase',
  }
  use {
    'danymat/neogen',
    config = function() require('neogen').setup { snippet_engine = 'luasnip' } end,
    requires = 'nvim-treesitter/nvim-treesitter',
    cmd = 'Neogen',
  }

  --------------------------------
  -- Workspace
  use {
    'kevinhwang91/nvim-bqf',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function() require 'plug.bqf' end,
    ft = 'qf',
  }
  use {
    'thinca/vim-qfreplace',
    cmd = 'Qfreplace',
    ft = 'qf',
  }

  --------------------------------------------------------------
  -- Others

  use {
    'tyru/open-browser.vim',
    map = '<Plug>(openbrowser-',
    opt = true,
  }
  use {
    'NTBBloodbath/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('rest-nvim').setup {} end,
    ft = 'http',
  }
  use {
    'sentriz/vim-print-debug',
    fn = 'print_debug#print_debug',
    config = function() vim.fn['plug#print_debug#config']() end,
  }
  use {
    'shiradofu/door2note.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'shiradofu/refresh.nvim', run = './refresh.sh restart', opt = false },
    },
    cmd = 'Door2NoteOpen',
    config = function() require 'plug.door2note' end,
  }

  --------------------------------------------------------------
  -- Appearance

  use {
    'folke/zen-mode.nvim',
    config = function() require 'plug.zen-mode' end,
    cmd = 'ZenMode',
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
      }
    end,
    opt = true,
  }

  use { 'cocopon/iceberg.vim', opt = true }
  use { 'rose-pine/neovim', as = 'rose-pine', module = 'rose-pine' }

  use {
    'xiyaowong/nvim-transparent',
    config = function() require 'plug.transparent' end,
  }
end)

if pcall(require, 'plug._compiled') then
  vim.defer_fn(function()
    packer.loader(
      -- 依存順序注意
      'vim-repeat',
      'editorconfig.nvim',
      'typescript.nvim',
      'SchemaStore.nvim',
      'nvim-jqx',
      'nvim-lspconfig',
      'null-ls.nvim',
      'nvim-lsp-installer',
      'lsp_signature.nvim',
      'nvim-code-action-menu',
      'nvim-treesitter',
      'gitsigns.nvim',
      'git-conflict.nvim',
      'vim-mergetool',
      'indent-blankline.nvim',
      'nvim-hlslens',
      'nvim-scrollbar',
      'nvim-colorizer.lua',
      'vim-better-whitespace',
      'vim-textobj-user',
      'substitute.nvim',
      'open-browser.vim'
    )
  end, 0)
end
