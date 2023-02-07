return {
  'shiradofu/door2note.nvim',
  cmd = 'Door2NoteOpen',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'shiradofu/refresh.nvim',
      build = './refresh.sh restart',
      lazy = false,
    },
  },
  config = function()
    local note_dir = vim.env.MY_REPOS .. '/_notes'

    local augroup = vim.api.nvim_create_augroup('MyDoor2Note', {})
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup,
      pattern = note_dir .. '/*',
      callback = function() vim.b.enable_auto_format = false end,
    })
    vim.api.nvim_create_autocmd('BufLeave', {
      group = augroup,
      pattern = note_dir .. '/*',
      callback = function() pcall(vim.cmd.write) end,
    })

    return require('door2note').setup {
      note_dir = note_dir,
      note_path = function(root)
        local gh = vim.env.GHQ_ROOT .. '/github.com/'
        if vim.startswith(root, gh) then return root:sub(#gh) .. '.md' end
        if vim.startswith(root, LAZY_DIR) then
          for _, plugin in ipairs(require('lazy').plugins()) do
            if plugin.name == root:match '[^/]+$' then
              return plugin[1] .. '.md'
            end
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
  end,
}
