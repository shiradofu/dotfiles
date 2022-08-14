require('project-note').setup {
  note_dir = vim.env.GHQ_ROOT .. '/github.com/shiradofu/_notes',
  note_path = function(root)
    local gh = vim.env.GHQ_ROOT .. '/github.com/'
    if vim.startswith(root, gh) then
      return root:sub(#gh) .. '.md'
    end
    if packer_plugins then
      local packer = ('^%s/packer/[^/]+/'):format(
        require('packer').config.package_root
      )
      local _, packer_n = root:find(packer)
      if packer_n then
        local name = root:sub(packer_n + 1)
        local plugin = packer_plugins[name]
        if not plugin then
          return ''
        end
        local url = plugin.url
        local gh_url = 'https://github.com/'
        if vim.startswith(url, gh_url) then
          return url:sub(#gh_url) .. '.md'
        end
      end
    end
    return ''
  end,
  auto_push = true,
  auto_pull = true,
  auto_delete_empty = true,
  branch = 'main',
}
