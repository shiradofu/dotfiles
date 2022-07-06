local install_path = vim.fn.stdpath "data"
  .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  print(install_path)
  return
end

vim.cmd [[packadd packer.nvim]]
require "plug/packer"

return require("packer").startup(function(use)
  use { "wbthomason/packer.nvim", opt = true }

  -- ------------------------------------------------------------
  -- Library

  --------------------------------
  -- Vim script Library
  use { "tpope/vim-repeat", event = "VimEnter" }

  --------------------------------
  -- Lua Library
  use "nvim-lua/plenary.nvim" -- do not lazy load
  use "antoinemadec/FixCursorHold.nvim"
  use "kyazdani42/nvim-web-devicons"
  -- use{ 'nvim-lua/popup.nvim', module = 'popup' }
  -- use{ 'tami5/sqlite.lua', module = 'sqlite' }
  -- use{ 'MunifTanjim/nui.nvim', module = 'nui' }

  --------------------------------
  -- Denops Library
  -- use {'vim-denops/denops.vim'}

  -- ------------------------------------------------------------
  -- Fundamental

  use {
    "mattn/vim-findroot",
    setup = function()
      vim.g.findroot_patterns = { ".git/" }
      vim.g.findroot_not_for_subdir = 0
    end,
  }

  -- ------------------------------------------------------------
  -- Treesitter & Text Objects

  --------------------------------
  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require "plug/treesitter"
    end,
  }
  use {
    "yioneko/nvim-yati", -- improve indentation
    event = { "BufEnter" },
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    "haringsrob/nvim_context_vt",
    config = function()
      require "plug/context-vt"
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    requires = "nvim-treesitter/nvim-treesitter",
  }

  --------------------------------
  -- Text Objects
  use {
    "kana/vim-textobj-user",
    event = "VimEnter",
    config = "vim.cmd[[call plug#textobj#setup()]]",
  }
  use {
    -- TODO: not working
    "sgur/vim-textobj-parameter",
    event = "VimEnter",
    after = { "vim-textobj-user" },
    requires = { "vim-textobj-user" },
  }
  use {
    "kana/vim-textobj-entire",
    event = "VimEnter",
    after = { "vim-textobj-user" },
  }
  use {
    "kana/vim-textobj-indent",
    event = "VimEnter",
    after = { "vim-textobj-user" },
  }
  use {
    "kana/vim-textobj-line",
    event = "VimEnter",
    after = { "vim-textobj-user" },
  }
  use {
    "glts/vim-textobj-comment",
    event = "VimEnter",
    after = { "vim-textobj-user" },
  }

  --------------------------------------------------------------
  -- LSP & Completion

  --------------------------------
  -- Language Server Protocol(LSP)

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "plug/lspconfig"
    end,
  }
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require "plug/lsp-signature"
    end,
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require "plug/null-ls"
    end,
  }
  use "jose-elias-alvarez/typescript.nvim"
  use "ray-x/go.nvim"
  use "b0o/SchemaStore.nvim"
  use "gennaro-tedesco/nvim-jqx"
  use {
    "williamboman/nvim-lsp-installer",
    -- TODO: requires 書く？
    -- requires = { 'lspconfig', 'cmp-lsp' },
    config = function()
      require "plug/lsp-installer"
    end,
  }

  --------------------------------
  -- Completion

  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require "plug/cmp"
    end,
    requires = { "LuaSnip" },
  }
  use {
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      require "plug/cmp-lsp"
    end,
  }
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "saadparwaiz1/cmp_luasnip"

  --------------------------------
  -- Snippet

  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require "plug/luasnip"
    end,
  }

  --------------------------------
  -- Other Features
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end,
  }
  use {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  }
  use "simrat39/symbols-outline.nvim"

  --------------------------------------------------------------
  -- Fuzzy Finder

  use {
    "junegunn/fzf",
    run = "./install --no-key-bindings --no-update-rc",
  }
  use {
    "junegunn/fzf.vim",
    config = "vim.cmd[[call plug#fzf#setup()]]",
    requires = { "fzf" },
  }

  -- use{
  -- 	'nvim-telescope/telescope.nvim',
  -- 	config = function()require'plug/telescope'end,
  -- }
  -- use{
  -- 'nvim-telescope/telescope-fzf-native.nvim',
  -- run = 'make',
  -- config = function()require('telescope').load_extension('fzf')end,
  -- }
  -- use{
  -- 	'nvim-telescope/telescope-frecency.nvim',
  -- 	after = { 'telescope.nvim' },
  -- 	config = function()require'telescope'.load_extension'frecency'end,
  -- }

  --------------------------------------------------------------
  -- Git

  -- use {
  --   "TimUntersberger/neogit",
  --   requires = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require "plug/neogit"
  --   end,
  -- }
  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "plug/diffview"
    end,
  }
  use {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    config = function()
      require "plug/gitsigns"
    end,
  }

  --------------------------------------------------------------
  -- Colorschemes

  use "xiyaowong/nvim-transparent"
end)
