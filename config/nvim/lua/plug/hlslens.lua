return {
  'kevinhwang91/nvim-hlslens',
  dependencies = 'shiradofu/nice-scroll.nvim',
  config = function()
    local config = {
      calm_down = true,
      nearest_only = true,
    }

    local ok, scrollbar = pcall(require, 'scrollbar.handlers.search')
    if ok then
      scrollbar.setup(config)
    else
      require('hlslens').setup(config)
    end
  end,
}
