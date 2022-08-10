local G = {}

local aug = vim.api.nvim_create_augroup('MyGit', {})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = aug,
  pattern = '.git/COMMIT_EDITMSG',
  command = 'startinsert',
})

-- nvim remote は開いたバッファが delete された時点で戻るので、
-- これらのバッファは常に hidden = deleted としておく
vim.api.nvim_create_autocmd('FileType', {
  group = aug,
  pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
  command = 'set bufhidden=delete',
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = aug,
  pattern = '.git/COMMIT_EDITMSG',
  command = 'startinsert',
})

local function _on_event()
  local output = {}
  return function(_, data, e)
    if e == 'exit' then
      output[#output][1] = output[#output][1]:gsub('\n*$', '')
      if data == 0 then
        for _, d in ipairs(output) do
          d[2] = 'None'
        end
      end
      vim.api.nvim_echo(output, true, {})
      return
    end
    data = table.concat(data, '\n')
    if data ~= '' then
      table.insert(output, { data, e == 'stdout' and 'None' or 'ErrorMsg' })
    end
  end
end

G.commit = function()
  local cmd = [[
  if ! git commit --dry-run >/dev/null 2>&1; then
    echo nothing staged.
    return
  fi
  GIT_EDITOR='nvr -cc tabedit --remote-wait' git commit]]

  local on_event = _on_event()
  vim.fn.jobstart(cmd, {
    on_stdout = on_event,
    on_stderr = on_event,
    on_exit = on_event,
    cwd = vim.loop.cwd(),
  })
end

G.push = function()
  local cmd = [[
    remote=$(git remote | head -n 1)
    if [ -z "$remote" ]; then
      echo "remote is not set."
      return
    fi
    if git name-rev @{u} >/dev/null 2>&1; then
      git push origin HEAD
    else
      git push -u origin HEAD
    fi]]

  local on_event = _on_event()
  vim.fn.jobstart(cmd, {
    on_stdout = on_event,
    on_stderr = on_event,
    on_exit = on_event,
    cwd = vim.loop.cwd(),
  })
end

return G
