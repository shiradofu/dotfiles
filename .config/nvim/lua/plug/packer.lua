local config_dir = vim.fn.stdpath 'config' .. '/nvim'

-- local augroup = vim.api.nvim_create_augroup("MyPacker", {})
-- vim.api.nvim_clear_autocmds { group = augroup }
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = {
--     config_dir .. "/lua/*.lua",
--     config_dir .. "/lua/plug/*.lua",
--     config_dir .. "/autoload/plug/*.vim",
--   },
--   command = "PackerCompile",
--   group = augroup,
-- })

-- M.is_plugin_installed = function(name)
--   return _G.packer_plugins[name] ~= nil
-- end

require('packer').init {
  compile_path = vim.fn.stdpath 'data'
    .. '/site/pack/loader/start/my-packer/plugin/packer.lua',
  display = {
    open_fn = require('packer.util').float,
  },
}
