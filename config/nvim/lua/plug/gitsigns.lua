return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  config = function()
    local mappings = require('user.mappings').gitsigns

    require('gitsigns').setup {
      signcolumn = false,
      numhl = true,
      on_attach = function(bufnr)
        local note_dir = vim.env.MY_REPOS .. '/_notes'
        if vim.startswith(vim.api.nvim_buf_get_name(bufnr), note_dir) then
          return false
        end
        mappings(package.loaded.gitsigns)
      end,
    }
  end,
}
