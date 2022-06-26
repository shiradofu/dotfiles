local installer = require"nvim-lsp-installer"
local lspconfig = require'lspconfig'
local config = require"plug/lspconfig"

local servers = {}
for key,_ in pairs(config) do
  table.insert(servers, key)
end

installer.setup{
  ensure_installed = servers,
  ui = {
    border = "none",
    icons = {
      server_installed = "✓",
      server_pending = "◎",
      server_uninstalled = "✗"
    }
  }
}

for _, server in ipairs(installer.get_installed_servers()) do
  lspconfig[server.name].setup(config[server.name])
end

