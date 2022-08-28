local note_dir = vim.env.GHQ_ROOT .. '/github.com/shiradofu/_notes'

local augroup = vim.api.nvim_create_augroup('MyDoor2Note', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  pattern = note_dir .. '/*',
  callback = function() vim.b.enable_auto_format = false end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = augroup,
  pattern = note_dir .. '/*',
  callback = function() pcall(vim.cmd, 'w') end,
})

return require('door2note').setup {
  note_dir = note_dir,
  note_path = function(root)
    local gh = vim.env.GHQ_ROOT .. '/github.com/'
    if vim.startswith(root, gh) then return root:sub(#gh) .. '.md' end
    if packer_plugins then
      local packer_root = require('packer').config.package_root
      packer_root = ('^%s/packer/[^/]+/'):format(packer_root)
      local _, packer_n = root:find(packer_root)
      if packer_n then
        local name = root:sub(packer_n + 1)
        local plugin = packer_plugins[name]
        if not plugin then return '' end
        local url = plugin.url
        local fname = url:match 'https://github%.com/(.+)%.git$'
          or url:match 'https://github%.com/(.+)'
        if fname then return fname .. '.md' end
      end
    end
    return ''
  end,
  hooks = {
    on_enter = function() require('gitsigns').detach() end,
  },
  integrations = {
    refresh = {
      enabled = true,
      pull = { silent = false },
      branch = 'main',
    },
  },
}
