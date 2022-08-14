vim.g.the_readonly_world = false

local function the_readonly_world()
  for c in ('qrtiopasdxcRIOPASDJXC<>.'):gmatch '.' do
    vim.keymap.set(
      { 'n', 'x' },
      c,
      '<Nop>',
      { remap = true, nowait = true, buffer = true }
    )
  end
end

local function peaceful_daily_life()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    for c in ('qrtiopasdxcRIOPASDJXC<>.'):gmatch '.' do
      pcall(
        vim.keymap.del,
        { 'n', 'x' },
        c,
        { remap = true, nowait = true, buffer = buf }
      )
    end
  end
end

local g = vim.api.nvim_create_augroup('MyReadonly', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = g,
  pattern = '*',
  callback = function()
    if vim.g.the_readonly_world then
      vim.defer_fn(the_readonly_world, 0)
    end
  end,
})

return function()
  vim.g.the_readonly_world = not vim.g.the_readonly_world
  if vim.g.the_readonly_world then
    the_readonly_world()
    print 'Welcome to the readonly world...'
  else
    peaceful_daily_life()
    print 'You realize just how happy a normal life is.'
  end
end
