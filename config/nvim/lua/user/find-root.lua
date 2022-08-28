---@param dir string
---@param patterns string[]
-- @return string|nil
local scan_dir = function(dir, patterns)
  if vim.loop.fs_access(dir, 'X') == false then
    print(('%s is not accessible by the current user.'):format(dir))
  end
  local fd = vim.loop.fs_scandir(dir)
  if not fd then return end
  while true do
    local name = vim.loop.fs_scandir_next(fd)
    if name == nil then break end
    local entry = dir .. '/' .. name
    for _, pat in ipairs(patterns) do
      if entry:match(pat) then return entry end
    end
  end
end

-- https://github.com/nvim-lua/plenary.nvim/issues/88#issuecomment-790738788
local function find_root(patterns, start)
  start = start and start or vim.loop.cwd()
  if start == '/' then return nil end
  if scan_dir(start, patterns) then return start end
  return find_root(patterns, vim.loop.fs_realpath(start .. '/../'))
end

return find_root
