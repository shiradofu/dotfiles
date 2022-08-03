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
  fd_additional_opts = '--color=never --hidden --follow --exclude .git',
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
  local sess_tbl = {}

  -- 重複を確認するためのテーブル
  local files_memo = {}

  if opts.include_current_session then
    for _, buffer in ipairs(vim.split(vim.fn.execute ':buffers! t', '\n')) do
      local bufnr = tonumber(buffer:match '%s*(%d+)')
      if bufnr then
        local file = vim.api.nvim_buf_get_name(bufnr)
        local fs_stat = not opts.stat_file and true or vim.loop.fs_stat(file)
        if #file > 0 and fs_stat and path.is_relative(file, cwd) then
          files_memo[file] = true
          table.insert(sess_tbl, file)
        end
      end
    end
  end

  local contents = function(cb)
    local function add_entry(x, co)
      x = make_entry.file(x, opts)
      if x then
        cb(x, function(err)
          coroutine.resume(co, 0)
          if err then
            cb(nil)
          end
        end)
      end
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

      local function on_event(_, data, event)
        if event == 'stdout' then
          for _, file in ipairs(data) do
            if file ~= '' and not files_memo[file] then
              add_entry(file, co)
            end
          end
        elseif event == 'stderr' then
          vim.cmd 'echohl Error'
          vim.cmd('echomsg "' .. table.concat(data, '') .. '"')
          vim.cmd 'echohl None'
          coroutine.resume(co, 2)
        elseif event == 'exit' then
          coroutine.resume(co, 1)
        end
      end

      local fd_cmd = 'fd --type f --absolute-path ' .. opts.fd_additional_opts
      vim.fn.jobstart(fd_cmd, {
        on_stderr = on_event,
        on_stdout = on_event,
        on_exit = on_event,
        cwd = cwd,
      })

      repeat
        -- waiting for a call to 'resume'
        local ret = coroutine.yield()
      until ret ~= 0

      cb(nil)
    end)()
  end

  -- for 'file_ignore_patterns' to work on relative paths
  opts.cwd = opts.cwd or vim.loop.cwd()
  opts = core.set_header(opts, opts.headers or { 'cwd' })
  return core.fzf_exec(contents, opts)
end
