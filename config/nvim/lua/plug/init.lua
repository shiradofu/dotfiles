return {
  --------------------------------------------------------------
  -- Editing

  'johmsalas/text-case.nvim',
  'shiradofu/print-debug.nvim',
  { 'gbprod/substitute.nvim', config = true },
  { 'thinca/vim-qfreplace', cmd = 'Qfreplace' },
  { 'norcalli/nvim-colorizer.lua', config = true },
  {
    't9md/vim-quickhl',
    keys = { { '<Plug>(quickhl-', mode = { 'n', 'x' } } },
  },
  {
    'kevinhwang91/nvim-hlslens',
    event = 'CmdlineEnter',
    dependencies = {
      { 'shiradofu/nice-scroll.nvim', config = true },
    },
    opts = { calm_down = true, nearest_only = true },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      labels = 'IJKHLUONMUPY():<>{}FGEAVCBWDRSZXTQ',
      search = {
        incremental = true,
      },
      modes = {
        search = {
          enabled = true,
          jump = { history = false, register = false, nohlsearch = true },
        },
        char = { enabled = false },
      },
    },
  },
  {
    'haya14busa/vim-asterisk',
    keys = '<Plug>(asterisk-',
    init = function() vim.g['asterisk#keeppos'] = 1 end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = { signs = false },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = 'nvim-treesiter/nvim-treesitter',
    opts = {
      preview = { delay_syntax = 0 },
      func_map = require('user.mappings').bqf(),
    },
  },
  {
    'danymat/neogen',
    cmd = 'Neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = { snippet_engine = 'nvim' },
  },

  --------------------------------------------------------------
  -- FileType

  { 'itchyny/vim-qfedit', ft = 'qf' },
  { 'Decodetalkers/csv-tools.lua', ft = 'csv' },
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod' },
    config = true,
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    'windwp/nvim-ts-autotag',
    config = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'vue', 'xml' },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown',
    keys = '<Plug>MarkdownPreviewToggle',
    cmd = 'MarkdownPreviewToggle',
  },
  {
    'NTBBloodbath/rest.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('rest-nvim').setup {} end,
    ft = 'http',
  },

  --------------------------------------------------------------
  -- Git

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs_staged_enable = false,
      signcolumn = false,
      numhl = true,
      on_attach = function()
        require('user.mappings').gitsigns(package.loaded.gitsigns)
      end,
    },
  },
  {
    'akinsho/git-conflict.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'samoshkin/vim-mergetool',
    cmd = 'MergetoolStart',
    init = function()
      vim.g.mergetool_layout = 'LmR'
      vim.g.mergetool_prefer_revision = 'base'
    end,
  },

  --------------------------------------------------------------
  -- Others
  { 'AckslD/messages.nvim', config = true, cmd = 'Message' },

  --------------------------------------------------------------
  -- Colorscheme

  {
    'xiyaowong/nvim-transparent',
    event = 'ColorScheme',
    opts = {
      exclude_groups = { 'FzfLuaNormal' },
    },
  },
  { 'cocopon/iceberg.vim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
}
