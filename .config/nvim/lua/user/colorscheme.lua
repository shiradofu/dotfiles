vim.g.material_style = 'lighter'

local cache_dir = vim.fn.stdpath 'cache'

math.randomseed(os.time())
while
  not pcall(
    vim.fn.serverstart,
    string.format('%s/server-%d.pipe', cache_dir, math.random(65535))
  )
do
end
