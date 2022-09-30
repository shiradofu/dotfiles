local mappgins = require('user.mappings').gitsigns

require('gitsigns').setup {
  on_attach = function(bufnr)
    local note_dir = vim.env.GHQ_ROOT .. '/github.com/shiradofu/_notes'
    if vim.startswith(vim.api.nvim_buf_get_name(bufnr), note_dir) then
      return false
    end
    mappgins(package.loaded.gitsigns)
  end,
}
