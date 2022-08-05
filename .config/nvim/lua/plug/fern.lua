local find_root = require 'user.find-root'
local mappings = require('user.mappings').fern_local

vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#default_hidden'] = 1

local fern = vim.api.nvim_create_augroup('MyFern', {})
vim.api.nvim_create_autocmd('FileType', {
  group = fern,
  pattern = 'fern',
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local git_root = find_root '/%.git$'
    local pos = 1
    if git_root then
      local parent = vim.loop.fs_realpath(git_root .. '/../')
      _, pos = bufname:find(parent)
      pos = pos + 2
    else
      pos = bufname:find [[file:///]]
    end
    vim.b.fern_name = bufname:sub(pos, -2)
    vim.api.nvim_buf_set_name(0, vim.b.fern_name)

    vim.cmd [[setlocal signcolumn=number]]
    mappings()
  end,
})
