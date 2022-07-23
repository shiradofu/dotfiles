function Log(x)
  print(vim.inspect(x))
end
local function r(modname, fn)
  return 'require("' .. modname .. '")' .. (fn and '.' .. fn .. '()' or '')
end
local function v(fn)
  return 'vim.fn["' .. fn .. '"]()'
end

local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  print(install_path)
  return
end

vim.cmd [[packadd packer.nvim]]
require 'plug.packer'

---@diagnostic disable-next-line: different-requires
return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  -- ------------------------------------------------------------
  -- Library

  --------------------------------
  -- Vim script Library
  use { 'tpope/vim-repeat', event = 'VimEnter' }

  --------------------------------
  -- Lua Library
  use 'nvim-lua/plenary.nvim' -- do not lazy load
  use 'antoinemadec/FixCursorHold.nvim'
  use 'kyazdani42/nvim-web-devicons'

  --------------------------------
  -- Denops Library
  use 'vim-denops/denops.vim'

  -- ------------------------------------------------------------
  -- Fundamental

  use {
    'mattn/vim-findroot',
    setup = function()
      vim.g.findroot_patterns = { '.git/' }
      vim.g.findroot_not_for_subdir = 0
    end,
  }
  use {
    'lambdalisue/fern.vim',
    requires = 'antoinemadec/FixCursorHold.nvim',
    branch = 'main',
    setup = function()
      vim.fn['plug#fern#setup']()
    end,
  }
  use 'lambdalisue/fern-hijack.vim'

  -- ------------------------------------------------------------
  -- Treesitter & Text Objects

  --------------------------------
  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = r 'plug.treesitter',
  }
  use {
    'yioneko/nvim-yati', -- improve indentation
    requires = 'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
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
    config = v 'plug#textobj#config',
  }
  use {
    'sgur/vim-textobj-parameter',
    event = 'VimEnter',
  }
  use {
    'kana/vim-textobj-entire',
    event = 'VimEnter',
  }
  use {
    'kana/vim-textobj-indent',
    event = 'VimEnter',
  }
  use {
    'kana/vim-textobj-line',
    event = 'VimEnter',
  }
  use {
    'glts/vim-textobj-comment',
    event = 'VimEnter',
  }
  use {
    'tpope/vim-commentary',
    keys = '<Plug>Commentary',
  }
  use {
    'machakann/vim-sandwich',
    setup = function()
      vim.fn['plug#sandwich#setup']()
    end,
    keys = '<Plug>(sandwich-',
  }
  use {
    'gbprod/substitute.nvim',
    config = r('substitute', 'setup'),
    module = 'substitute',
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
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require 'plug.null-ls'
    end,
  }
  use 'jose-elias-alvarez/typescript.nvim'
  use 'ray-x/go.nvim'
  use 'b0o/SchemaStore.nvim'
  use 'gennaro-tedesco/nvim-jqx'
  use {
    'williamboman/nvim-lsp-installer',
    -- TODO: requires 書く？
    -- requires = { 'lspconfig', 'cmp-lsp' },
    config = function()
      require 'plug.lsp-installer'
    end,
  }
  -- use {
  --   'ray-x/lsp_signature.nvim',
  --   config = function()
  --     require 'plug.lsp-signature'
  --   end,
  -- }

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
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    config = function()
      require 'plug.cmp-lsp'
    end,
  }
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'saadparwaiz1/cmp_luasnip'

  --------------------------------
  -- Snippet
  use {
    'L3MON4D3/LuaSnip',
    config = function()
      require 'plug.luasnip'
    end,
  }

  --------------------------------
  -- Other Features
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {}
    end,
    cmd = { 'Trouble', 'TroubleToggle' },
  }
  use {
    'weilbith/nvim-code-action-menu',
    config = function()
      require 'plug.code-action-menu'
    end,
  }
  use {
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
  }
  use 'gpanders/editorconfig.nvim'

  --------------------------------------------------------------
  -- Testing and Debugging

  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'haydenmeade/neotest-jest',
      'shiradofu/neotest-vitest',
      'olimorris/neotest-phpunit',
    },
    config = r 'plug.neotest',
  }
  use {
    'shiradofu/neotest-vitest',
    branch = 'follow-neotest-jest-12138a1',
  }

  --------------------------------------------------------------
  -- Fuzzy Finder

  use {
    'junegunn/fzf',
    run = function()
      vim.fn['fzf#install']()
    end,
  }
  use {
    'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = r 'plug.fzf',
  }
  use {
    'junegunn/fzf.vim',
    config = 'vim.cmd[[call plug#fzf#setup()]]',
    requires = { 'fzf' },
  }

  -- use {
  --   "nvim-telescope/telescope.nvim",
  --   requires = { "nvim-lua/plenary.nvim" },
  -- }
  -- use{
  -- 'nvim-telescope/telescope-fzf-native.nvim',
  -- run = 'make',
  -- config = function()require('telescope').load_extension('fzf')end,
  -- }
  -- use{
  --  'nvim-telescope/telescope-frecency.nvim',
  --  after = { 'telescope.nvim' },
  --  config = function()require'telescope'.load_extension'frecency'end,
  -- }

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
    tag = 'release',
    config = function()
      require 'plug.gitsigns'
    end,
  }
  use {
    'lambdalisue/gin.vim',
    requires = 'vim-denops/denops.vim',
  }
  use {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end,
  }
  use {
    'samoshkin/vim-mergetool',
    setup = function()
      vim.g.mergetool_layout = 'LmR'
      vim.g.mergetool_prefer_revision = 'base'
    end,
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
  }
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require 'plug.hlslens'
    end,
    module = 'hlslens',
    keys = { '/' },
  }
  use {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup {}
    end,
  }
  -- TODO: 必要性検証
  -- use {
  --   'deris/vim-shot-f',
  --   setup = function()
  --     vim.g.shot_f_no_default_key_mappings = true
  --   end,
  --   keys = { '<Plug>(shot-f-' },
  -- }
  -- TODO: 必要性検証
  use {
    'rhysd/clever-f.vim',
    setup = v 'plug#clever_f#setup',
    keys = { '<Plug>(clever-f-' },
  }
  -- TODO: 必要性検証
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
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
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

  --------------------------------
  -- Workspace
  use {
    'kevinhwang91/nvim-bqf',
    requires = {
      'junegunn/fzf',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = 'qf',
  }
  use {
    'thinca/vim-qfreplace',
    cmd = 'Qfreplace',
    ft = 'qf',
  }

  --------------------------------------------------------------
  -- Others

  use 'tyru/open-browser.vim'
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

  -- use {
  --   'Pocco81/TrueZen.nvim',
  --   config = function()
  --     require 'plug.truezen'
  --   end,
  --   cmd = { 'TZAtaraxis', 'TZMinimalist', 'TZFocus' },
  -- }
  use {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {}
    end,
  }
  use {
    'kwkarlwang/bufresize.nvim',
    config = function()
      require('bufresize').setup()
    end,
    event = 'WinNew',
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
  }
  use {
    'luukvbaal/stabilize.nvim',
    config = function()
      require('stabilize').setup()
    end,
    event = 'WinNew',
  }
  use 'EdenEast/nightfox.nvim'
  use 'shaunsingh/nord.nvim'
  use 'sainnhe/everforest'
  use 'yuttie/hydrangea-vim'
  use 'xiyaowong/nvim-transparent'
end)
