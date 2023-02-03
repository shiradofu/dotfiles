return {
  'xiyaowong/nvim-transparent',
  event = 'ColorScheme',
  config = function()
    require('transparent').setup {
      enable = true,
      extra_groups = {
        'GitGutterAdd',
        'GitGutterChange',
        'GitGutterDelete',
        'GitGutterChangeDelete',
      },
    }
  end,
}
