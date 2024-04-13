return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  dependencies = 'nvim-treesiter/nvim-treesitter',
  config = function()
    require('bqf').setup {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        delay_syntax = 0,
      },
      func_map = require('user.mappings').bqf(),
    }
  end,
}
