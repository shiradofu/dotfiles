return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  init = function() vim.g.skip_ts_context_commentstring_module = true end,
  event = 'VeryLazy',
  config = function()
    local mappings = require 'user.mappings'
    require('ts_context_commentstring').setup {
      commentary_integration = mappings.commentary(),
      languages = {
        cpp = { __default = '// %s', __multiline = '/* %s */' },
      },
    }
  end,
}
