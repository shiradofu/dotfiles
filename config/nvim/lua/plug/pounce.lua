return {
  'rlane/pounce.nvim',
  cmd = 'Pounce',
  config = function()
    require('pounce').setup {
      accept_keys = 'IJKHLUONMUPY():<>|{}FGEAVCBWDRSZXTQ',
      accept_best_key = '<enter>',
      multi_window = true,
      debug = false,
    }
  end,
}
