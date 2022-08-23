local mappgins = require('user.mappings').gitsigns

require('gitsigns').setup {
  signs = {
    add = {
      hl = 'GitSignsAdd',
      text = '‖',
      numhl = 'GitSignsAddNr',
      linehl = 'GitSignsAddLn',
    },
    change = {
      hl = 'GitSignsChange',
      text = '‖',
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
    delete = {
      hl = 'GitSignsDelete',
      text = '‖',
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    topdelete = {
      hl = 'GitSignsDelete',
      text = '‾',
      numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn',
    },
    changedelete = {
      hl = 'GitSignsChange',
      text = '‖',
      numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn',
    },
  },
  on_attach = function(bufnr)
    local note_dir = vim.env.GHQ_ROOT .. '/github.com/shiradofu/_notes'
    if vim.startswith(vim.api.nvim_buf_get_name(bufnr), note_dir) then
      return false
    end
    mappgins(package.loaded.gitsigns)
  end,
}
