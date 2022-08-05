local util = require 'packer.util'

local augroup = vim.api.nvim_create_augroup('MyPacker', {})
vim.api.nvim_clear_autocmds { group = augroup }
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = {
    util.join_paths(vim.g.config_dir, 'lua', 'plug', 'init.lua'),
  },
  command = 'PackerCompile',
  group = augroup,
})

require('packer').init {
  compile_path = util.join_paths(
    vim.g.config_dir,
    'lua',
    'plug',
    '_compiled.lua'
  ),
  display = { open_fn = util.float },
}
