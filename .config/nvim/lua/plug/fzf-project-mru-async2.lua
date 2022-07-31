local core = require 'fzf-lua.core'
local config = require 'fzf-lua.config'
local make_entry = require 'fzf-lua.make_entry'
local path = require 'fzf-lua.path'

local config_globals_project_mru = {
  previewer = config._default_previewer_fn,
  prompt = 'MRU> ',
  file_icons = true and config._has_devicons,
  color_icons = true,
  git_icons = false,
  stat_file = true,
  fd_additional_opts = {
    '-I',
    '--color=never',
    '--hidden',
    '--follow',
    '--exclude',
    '.git',
  },
  _actions = function()
    return config.globals.actions.files
  end,
}

config_globals_project_mru.include_current_session = true

return function(opts)
  opts = config.normalize_opts(opts, config_globals_project_mru)
  if not opts then
    return
  end

  local cwd = opts.cwd or vim.loop.cwd()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buffer)
  local sess_tbl = {}

  local files_memo = {}
  files_memo[current_file] = true

  if opts.include_current_session then
    for _, buffer in ipairs(vim.split(vim.fn.execute ':buffers! t', '\n')) do
      local bufnr = tonumber(buffer:match '%s*(%d+)')
      if bufnr then
        local file = vim.api.nvim_buf_get_name(bufnr)
        local fs_stat = not opts.stat_file and true or vim.loop.fs_stat(file)
        if #file > 0 and fs_stat and bufnr ~= current_buffer then
          files_memo[file] = true
          table.insert(sess_tbl, file)
        end
      end
    end
  end

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local git_files_tbls = {}
  local fd_done = false

  _FD_HANDLE = vim.loop.spawn('fd', {
    args = {
      '--type',
      'f',
      '--absolute-path',
      unpack(opts.fd_additional_opts),
    },
    stdio = { nil, stdout, stderr },
  }, function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    _FD_HANDLE:close()
    fd_done = true
  end)

  vim.loop.read_start(stdout, function(_, data)
    if data then
      local files = vim.split(data, '\n')
      git_files_tbls[#git_files_tbls + 1] = files
    end
  end)
  vim.loop.read_start(stderr, function(err, _)
    print(vim.inspect(err))
  end)

  local contents = function(cb)
    local function add_entry(x, co)
      x = make_entry.file(x, opts)
      if not x then
        return
      end
      cb(x, function(err)
        coroutine.resume(co)
        if err then
          -- close the pipe to fzf, this
          -- removes the loading indicator in fzf
          cb(nil)
        end
      end)
      coroutine.yield()
    end
    -- run in a coroutine for async progress indication
    coroutine.wrap(function()
      local co = coroutine.running()

      for _, file in ipairs(sess_tbl) do
        add_entry(file, co)
      end

      -- local start = os.time(); for _ = 1,10000,1 do
      for _, file in ipairs(vim.v.oldfiles) do
        local fs_stat = not opts.stat_file and true or vim.loop.fs_stat(file)
        if fs_stat and not files_memo[file] and path.is_relative(file, cwd) then
          files_memo[file] = true
          add_entry(file, co)
        end
      end
      -- end; print("took", os.time()-start, "seconds.")

      local i = 1
      while not fd_done or git_files_tbls[i] do
        local files = git_files_tbls[i]
        if files then
          for _, file in ipairs(files) do
            if file ~= '' and not files_memo[file] then
              add_entry(file, co)
            end
          end
          i = i + 1
        end
      end

      -- done
      cb(nil)
    end)()
  end

  -- for 'file_ignore_patterns' to work on relative paths
  opts.cwd = opts.cwd or vim.loop.cwd()
  opts = core.set_header(opts, opts.headers or { 'cwd' })
  return core.fzf_exec(contents, opts)
end
