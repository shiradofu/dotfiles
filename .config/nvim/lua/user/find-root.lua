local scan = require 'plenary.scandir'

-- https://github.com/nvim-lua/plenary.nvim/issues/88#issuecomment-790738788
local function find_root(patterns, start)
  start = start and start or vim.loop.cwd()
  if type(patterns) == 'string' then
    patterns = { patterns }
  end
  assert(type(start) == 'string')
  assert(type(patterns) == 'table')

  if start == '/' then
    return nil
  end

  for _, p in ipairs(patterns) do
    if
      #scan.scan_dir(start, {
        search_pattern = p,
        hidden = true,
        add_dirs = true,
        depth = 1,
      }) > 0
    then
      return start
    end
  end
  return find_root(patterns, vim.loop.fs_realpath(start .. '/../'))
end

return find_root
