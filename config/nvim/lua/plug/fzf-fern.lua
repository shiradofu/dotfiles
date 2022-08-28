local util = require 'user.util'

return function(noignore)
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local bufname = vim.b.fern.visible_nodes[lnum].bufname
  local dir = ''
  if vim.endswith(bufname, '$') then
    dir = bufname:match 'fern:///file://(.+)%$$'
  else
    dir = vim.loop.fs_realpath(bufname .. '/../')
  end
  if not dir then print(('dir %s not found.'):format(dir)) end
  local fzf_opts = { cwd = dir }
  if noignore then fzf_opts.rg_opts = util.fzf_rg_noignore end
  require('fzf-lua').live_grep_glob(fzf_opts)
end
