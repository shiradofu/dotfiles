return {
  'tyru/open-browser.vim',
  keys = { { '<Plug>(openbrowser-', mode = { 'n', 'v' } } },
  cmd = 'OpenGithubFile',
  dependencies = {
    { 'tyru/open-browser-github.vim' },
  },
  config = function()
    -- plugin 管理ファイルのリポジトリ名上で起動するとgithub のページを表示
    vim.keymap.set(
      'n',
      '<Plug>(openbrowser-smart-search-repo-aware)',
      function()
        if
          vim.startswith(
            vim.api.nvim_buf_get_name(0),
            vim.env.MY_REPOS .. '/dotfiles/config/nvim/lua/plug/'
          )
        then
          local cWORD = vim.fn.expand '<cWORD>'
          local repo = cWORD:match [=[['"]([^/'""]+/[^/'"]+)['"]]=]
          if repo then
            return vim.fn['openbrowser#open']('https://github.com/' .. repo)
          end
        end
        vim.fn['openbrowser#_keymap_smart_search'] 'n'
      end,
      { remap = true }
    )
  end,
}
