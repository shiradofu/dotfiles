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
    'danymat/neogen',
    cmd = 'Neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = { snippet_engine = 'luasnip' },
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

  { 'xiyaowong/nvim-transparent', event = 'ColorScheme' },
  { 'cocopon/iceberg.vim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
}
