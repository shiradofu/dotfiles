local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  print(install_path)
  return
end

vim.cmd [[packadd packer.nvim]]
require 'plug.packer'

require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -- ------------------------------------------------------------
  -- Library

  use 'nvim-lua/plenary.nvim' -- do not lazy load
  use { 'tpope/vim-repeat', opt = true }
  use { 'vim-denops/denops.vim', opt = true }

  -- ------------------------------------------------------------
  -- Fundamental

  use {
    'lambdalisue/fern.vim',
    requires = 'antoinemadec/FixCursorHold.nvim',
    branch = 'main',
    setup = function()
      require 'plug.fern'
    end,
  }
  use 'lambdalisue/fern-hijack.vim'
  use 'lewis6991/impatient.nvim'
  use {
    'nathom/filetype.nvim',
    config = function()
      require 'plug.filetype'
    end,
  }

  -- ------------------------------------------------------------
  -- Treesitter & Text Objects

  --------------------------------
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'plug.treesitter'
    end,
    opt = true,
  }
  use {
    'yioneko/nvim-yati', -- improve indentation
    requires = 'nvim-treesitter/nvim-treesitter',
    opt = true,
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter',
    opt = true,
  }
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      { 'tpope/vim-commentary' },
    },
    opt = true,
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
    config = function()
      vim.fn['plug#textobj#config']()
    end,
    opt = true,
  }
  use { 'sgur/vim-textobj-parameter', opt = true }
  use { 'kana/vim-textobj-entire', opt = true }
  use { 'kana/vim-textobj-indent', opt = true }
  use { 'kana/vim-textobj-line', opt = true }
  use { 'glts/vim-textobj-comment', opt = true }
  use {
    'machakann/vim-sandwich',
    setup = function()
      vim.fn['plug#sandwich#setup']()
    end,
    keys = '<Plug>(sandwich-',
  }
  use {
    'gbprod/substitute.nvim',
    config = function()
      require('substitute').setup {}
    end,
    opt = true,
  }

  --------------------------------------------------------------
  -- Language & Completion

  --------------------------------
  -- Language Server Protocol(LSP)
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require 'plug.lspconfig'
    end,
    opt = true,
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require 'plug.null-ls'
    end,
    opt = true,
  }
  use 'jose-elias-alvarez/typescript.nvim'
  use 'b0o/SchemaStore.nvim'
  use 'gennaro-tedesco/nvim-jqx'
  use {
    'ray-x/go.nvim',
    ft = 'go',
    config = function()
      require('go').setup()
    end,
  }
  use {
    'williamboman/nvim-lsp-installer',
    config = function()
      require 'plug.lsp-installer'
    end,
    opt = true,
  }
  use {
    'ray-x/lsp_signature.nvim',
    config = function()
      require 'plug.lsp-signature'
    end,
    opt = true,
  }

  --------------------------------
  -- Filetype
  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'vue', 'xml' },
  }
  use {
    'plasticboy/vim-markdown',
    setup = function()
      vim.fn['plug#markdown#setup']()
    end,
    ft = 'markdown',
  }
  use {
    'jkramer/vim-checkbox',
    setup = function()
      vim.fn['plug#checkbox#setup']()
    end,
    ft = 'markdown',
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
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
  use {
    'Shougo/vinarise.vim',
    cmd = 'Vinarise',
  }

  --------------------------------
  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require 'plug.cmp'
    end,
    requires = { 'LuaSnip' },
    opt = true,
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    config = function()
      require 'plug.cmp-lsp'
    end,
    opt = true,
  }
  use { 'hrsh7th/cmp-buffer', opt = true }
  use { 'hrsh7th/cmp-path', opt = true }
  use { 'hrsh7th/cmp-cmdline', opt = true }
  use { 'saadparwaiz1/cmp_luasnip', opt = true }
  use { 'lukas-reineke/cmp-rg', opt = true }
  use { 'davidsierradz/cmp-conventionalcommits', opt = true }

  --------------------------------
  -- Snippet
  use {
    'L3MON4D3/LuaSnip',
    config = function()
      require 'plug.luasnip'
    end,
    opt = true,
  }

  --------------------------------
  -- Other Features
  use {
    'weilbith/nvim-code-action-menu',
    config = function()
      require 'plug.code-action-menu'
    end,
    opt = true,
  }
  use 'gpanders/editorconfig.nvim'

  --------------------------------------------------------------
  -- Testing and Debugging

  use {
    'nvim-neotest/neotest',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'antoinemadec/FixCursorHold.nvim' },
      { 'haydenmeade/neotest-jest' },
      { 'shiradofu/neotest-vitest' },
      { 'olimorris/neotest-phpunit' },
      { 'nvim-neotest/neotest-go' },
    },
    config = function()
      require 'plug.neotest'
    end,
    opt = true,
  }

  --------------------------------------------------------------
  -- Fuzzy Finder

  use {
    'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require 'plug.fzf'
    end,
    opt = true,
  }

  --------------------------------------------------------------
  -- Git

  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require 'plug.diffview'
    end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'plug.gitsigns'
    end,
    opt = true,
  }
  use {
    'lambdalisue/gin.vim',
    requires = 'vim-denops/denops.vim',
    opt = true,
  }
  use {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end,
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
    cmd = 'OpenGithubFile',
  }

  --------------------------------------------------------------
  -- Editing

  --------------------------------
  -- Inside buffer
  use {
    'haya14busa/vim-asterisk',
    keys = { '<Plug>(asterisk-' },
    setup = function()
      vim.g['asterisk#keeppos'] = 1
    end,
    opt = true,
  }
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require 'plug.hlslens'
    end,
    opt = true,
  }
  use {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup {}
    end,
    opt = true,
  }
  use {
    'rhysd/clever-f.vim',
    setup = function()
      vim.fn['plug#clever_f#setup']()
    end,
    keys = { '<Plug>(clever-f-' },
  }
  use {
    'yuki-yano/fuzzy-motion.vim',
    config = function()
      -- stylua: ignore
      vim.g.fuzzy_motion_labels = {
        'I', 'H', 'J', 'K', 'L', 'U', 'O', 'N', 'M',
        'P', 'Y', 'F', 'G', 'E', 'A', 'V', 'C', 'B',
        'W', 'D', 'R', 'S', 'Z', 'X', 'T', 'Q',
      }
    end,
    requires = 'vim-denops/denops.vim',
    opt = true,
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
    opt = true,
  }
  use {
    't9md/vim-quickhl',
    keys = '<Plug>(quickhl-',
  }
  use {
    'ntpeters/vim-better-whitespace',
    setup = function()
      vim.fn['plug#whitespace#setup']()
    end,
    opt = true,
  }
  use {
    'windwp/nvim-autopairs',
    config = function()
      require 'plug.autopairs'
    end,
    event = 'InsertEnter',
  }
  use {
    'johmsalas/text-case.nvim',
    module = 'textcase',
  }
  use {
    'danymat/neogen',
    config = function()
      require('neogen').setup { snippet_engine = 'luasnip' }
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
    cmd = 'Neogen',
  }

  --------------------------------
  -- Workspace
  use {
    'kevinhwang91/nvim-bqf',
    requires = {
      'junegunn/fzf',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require 'plug.bqf'
    end,
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
    opt = true,
  }
  use {
    'NTBBloodbath/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('rest-nvim').setup {}
    end,
    ft = 'http',
  }
  use {
    'sentriz/vim-print-debug',
    fn = 'print_debug#print_debug',
    config = function()
      vim.fn['plug#print_debug#config']()
    end,
  }

  --------------------------------------------------------------
  -- Appearance

  use {
    'folke/zen-mode.nvim',
    config = function()
      require 'plug.zen-mode'
    end,
    cmd = 'ZenMode',
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
      }
    end,
  }

  use {
    'mcchrish/zenbones.nvim',
    requires = 'rktjmp/lush.nvim',
  }
  use 'olivercederborg/poimandres.nvim'
  use 'marko-cerovac/material.nvim'

  use {
    'xiyaowong/nvim-transparent',
    config = function()
      require('transparent').setup { enable = true }
    end,
  }
end)
