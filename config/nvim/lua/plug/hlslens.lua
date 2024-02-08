return {
  'kevinhwang91/nvim-hlslens',
  event = 'CmdlineEnter',
  dependencies = {
    { 'shiradofu/nice-scroll.nvim', config = true },
  },
  opts = {
    calm_down = true,
    nearest_only = true,
  },
}
