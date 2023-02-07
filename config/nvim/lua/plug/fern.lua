return {
  'lambdalisue/fern.vim',
  lazy = false,
  branch = 'main',
  dependencies = { 'lambdalisue/fern-hijack.vim' },
  init = function()
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
        local git_root = find_root { '/%.git$' }
        if git_root then
          local parent = vim.loop.fs_realpath(git_root .. '/../')
          if parent then parent = parent:gsub('-', '%%-') end
          bufname = bufname:match(parent .. '/(.+)%$$') or ''
        end
        vim.b.fern_name = bufname
        -- vim.api.nvim_buf_set_name(0, vim.b.fern_name)

        vim.cmd [[setlocal signcolumn=number]]
        mappings()
      end,
    })

    local function fern_diffview_map(map, cmd)
      vim.keymap.set('n', '<Plug>(fern-diffview-' .. map .. ')', function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        local fullpath = vim.b.fern.visible_nodes[lnum].bufname
        local win_id = vim.api.nvim_get_current_win()
        if cmd:find '%%' then
          if vim.fn.isdirectory(fullpath) == 1 then return end
          vim.cmd('e ' .. fullpath)
        else
          vim.cmd 'enew'
        end
        vim.cmd(cmd)
        local diffview = vim.api.nvim_get_current_tabpage()
        vim.api.nvim_set_current_win(win_id)
        vim.cmd [[exe "normal! \<C-o>"]]
        vim.api.nvim_set_current_tabpage(diffview)
      end, { remap = true })
    end
    fern_diffview_map('single-file-diff', 'DiffviewOpen -- %')
    fern_diffview_map('single-file-history', 'DiffviewFileHistory %')
    fern_diffview_map('git-status', 'DiffviewOpen')
    fern_diffview_map('diff-by-main', 'DiffviewOpen main')
    fern_diffview_map('all-files-history', 'DiffviewFileHistory')
  end,
}
