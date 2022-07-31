vim.g.material_style = 'lighter'

local cache_dir = vim.fn.stdpath 'cache'

local function listen()
  while
    not pcall(
      vim.fn.serverstart,
      string.format('%s/server-%d.pipe', cache_dir, math.random(65535))
    )
  do
  end
end

vim.defer_fn(listen, 100)
