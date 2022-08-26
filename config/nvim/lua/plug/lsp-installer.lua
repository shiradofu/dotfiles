local installer = require 'nvim-lsp-installer'
local lspconfig = require 'lspconfig'
local config = require 'plug.lspconfig'
local cmp = require 'plug.cmp-lsp'

installer.setup {
  ensure_installed = vim.tbl_keys(config),
  ui = {
    border = 'rounded',
    icons = {
      server_installed = '✓',
      server_pending = '◎',
      server_uninstalled = '-',
    },
  },
}

for _, server in ipairs(installer.get_installed_servers()) do
  config[server.name].capabilities = cmp
  if server.name == 'tsserver' then
    require('typescript').setup { server = config[server.name] }
  else
    lspconfig[server.name].setup(config[server.name])
  end
end

local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match 'warning: multiple different client offset_encodings' then
    return
  end
  notify(msg, ...)
end
