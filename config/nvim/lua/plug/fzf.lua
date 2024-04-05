-----------------------------
--                         --
--       Project MRU       --
--                         --
-----------------------------
local function setup_project_mru()
  local core = require 'fzf-lua.core'
  local config = require 'fzf-lua.config'
  local make_entry = require 'fzf-lua.make_entry'
  local path = require 'fzf-lua.path'
  local defaults = require 'fzf-lua.defaults'

  local default_opts = {
    previewer = defaults._default_previewer_fn,
    prompt = 'MRU> ',
    file_icons = true,
    color_icons = true,
    git_icons = false,
    stat_file = true,
    fd_additional_opts = '--color=never --hidden --follow --exclude .git',
    _actions = function() return config.globals.actions.files end,
    exclude = function(file) return file:find '/%.git/' end,
  }

  return function(opts)
    opts = config.normalize_opts(opts, default_opts)
    if not opts then return end

    local cwd = opts.cwd or vim.loop.cwd()
    local sess_tbl = {}

    -- 重複を確認するためのテーブル
    local files_memo = {}

    for _, buffer in ipairs(vim.split(vim.fn.execute ':buffers! t', '\n')) do
      local bufnr = tonumber(buffer:match '%s*(%d+)')
      if bufnr then
        local file = vim.api.nvim_buf_get_name(bufnr)
        local fs_stat = not opts.stat_file and true or vim.loop.fs_stat(file)
        if
          #file > 0
          and fs_stat
          and path.is_relative_to(file, cwd)
          and not opts.exclude(file)
        then
          files_memo[file] = true
          table.insert(sess_tbl, file)
        end
      end
    end

    local contents = function(cb)
      local function add_entry(x, co)
        x = make_entry.file(x, opts)
        if x then
          cb(x, function(err)
            coroutine.resume(co, 0)
            if err then cb(nil) end
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
          if
            fs_stat
            and not files_memo[file]
            and path.is_relative_to(file, cwd)
            and not opts.exclude(file)
          then
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
end

------------------------------
--                          --
--         Template         --
--                          --
------------------------------
local function setup_template()
  local core = require 'fzf-lua.core'
  local config = require 'fzf-lua.config'
  local path = require 'fzf-lua.path'
  local defaults = require 'fzf-lua.defaults'

  local function actions_read_file(selected, opts)
    local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
    local fullpath = entry.path or entry.uri and entry.uri:match '^%a+://(.*)'
    if not path.starts_with_separator(fullpath) then
      fullpath = path.join { opts.cwd, fullpath }
    end
    local tmpbuf = vim.api.nvim_create_buf(false, true)
    local aborted = false
    vim.api.nvim_buf_call(tmpbuf, function()
      vim.cmd('silent! read ' .. fullpath)
      vim.cmd 'normal! kdd'
      local var_memo = {}
      while true do
        -- e: move the cursor to the End of the match
        -- z: start searching at the cursor column instead of Zero
        -- W: don't Wrap around the end of the file
        local matchln = vim.fn.search('{{_input_:.*}}', 'ezW')
        if matchln == 0 then break end
        local matchline = vim.api.nvim_get_current_line()
        local s, e = matchline:find '{{_input_:[^}]+}}'
        local var_name = matchline:sub(s + 10, e - 2)
        if var_name == '' then var_name = 'input' end
        local var_value = ''
        if var_memo[var_name] then
          var_value = var_memo[var_name]
        else
          vim.ui.input({ prompt = var_name .. ': ' }, function(input)
            if not input then
              aborted = true
            else
              var_value = input
              var_memo[var_name] = var_value
            end
          end)
        end
        if aborted then break end
        local replaced = matchline:sub(1, s - 1)
          .. var_value
          .. matchline:sub(e + 1)
        vim.api.nvim_set_current_line(replaced)
        vim.fn.cursor(matchln, s)
      end
    end)

    if aborted then
      vim.api.nvim_echo({ { 'Aborted.', 'ErrorMsg' } }, false, {})
      return
    end
    local replacement = vim.api.nvim_buf_get_lines(tmpbuf, 0, -1, true)
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line, current_line, true, replacement)

    if
      vim.api.nvim_win_get_cursor(0)[1] == 1
      and vim.api.nvim_get_current_line() == ''
    then
      vim.api.nvim_del_current_line()
    end
  end

  local config_globals_templates = {
    previewer = defaults._default_previewer_fn,
    prompt = 'Templates{}> ',
    prompt_sep = '@',
    -- should use get_files_cmd in fzf-lua.files
    cmd = [[fd --color=never --type f --hidden --follow --exclude .git]],
    multiprocess = true,
    file_icons = true,
    color_icons = true,
    git_icons = false,
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = "--color=never --files --hidden --follow -g '!.git'",
    fd_opts = '--color=never --type f --hidden --follow --exclude .git',
    _actions = function()
      local a = vim.deepcopy(config.globals.actions.files)
      a.default = actions_read_file
      return a
    end,
    subdir = function() return vim.bo.ft end,
  }

  local _opts = {
    template_dir = os.getenv 'XDG_DATA_HOME' .. '/templates/',
    subdir = function(template_dir)
      local bufname = vim.api.nvim_buf_get_name(0)
      local basename = path.basename(bufname)
      -- ファイル名が . から始まっている場合は . を削除
      if vim.startswith(basename, '.') then basename = basename:sub(2) end
      local ft = vim.bo.ft
      if vim.fn.isdirectory(template_dir .. basename) == 1 then
        return basename
      elseif basename == 'docker-compose.override.yml' then
        return 'docker-compose.yml'
      elseif vim.endswith(basename, '.conf') then
        return 'conf'
      elseif ft == 'dockerfile' then
        return ft
      elseif vim.startswith(basename, 'eslintrc.') then
        return 'eslint'
      elseif bufname:find '/%.github/workflows/.*%.ya?ml$' then
        return 'github-actions'
      elseif basename:find '^prettierrc%.?' then
        return 'prettier'
      elseif vim.startswith(ft, 'typescript') then
        return 'typescript'
      else
        return ft
      end
    end,
  }

  config_globals_templates =
    vim.tbl_deep_extend('keep', _opts, config_globals_templates)

  return function(opts)
    opts = config.normalize_opts(opts, config_globals_templates)
    if not opts or not opts.template_dir then return end
    assert(
      type(opts.template_dir) == 'string'
        and vim.fn.isdirectory(opts.template_dir),
      'opts.template_dir must be a directory.'
    )

    opts.template_dir = vim.fn.fnamemodify(opts.template_dir, ':p')
    local ok, subdir = pcall(opts.subdir, opts.template_dir)
    if ok then opts.cwd = opts.template_dir .. subdir end
    if vim.fn.isdirectory(opts.cwd) == 0 then
      opts.cwd = opts.template_dir
      subdir = ''
    end
    if subdir ~= '' then
      opts.prompt = opts.prompt:gsub('{}', (opts.prompt_sep or '@') .. subdir)
    else
      opts.prompt = opts.prompt:gsub('{}', '')
    end

    local contents = core.mt_cmd_wrapper(opts)
    core.fzf_exec(contents, opts)
  end
end

-----------------------------
--                         --
--      Grep fern dir      --
--                         --
-----------------------------
local function setup_grep_fern_dir()
  local util = require 'user.util'
  return function(opts)
    opts = opts or {}

    -- get cursor node
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local bufname = vim.b.fern.visible_nodes[lnum].bufname

    local dir = ''
    if vim.endswith(bufname, '$') then
      dir = bufname:match 'fern:///file://(.+)%$$'
    else
      dir = vim.loop.fs_realpath(bufname .. '/../')
    end
    if not dir then print(('dir %s not found.'):format(dir)) end
    local fzf_opts = vim.tbl_deep_extend('force', { cwd = dir }, opts)
    require('fzf-lua').live_grep_glob(fzf_opts)
  end
end

------------------------------
--                          --
--           Main           --
--                          --
------------------------------
return {
  'ibhagwan/fzf-lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local fzf = require 'fzf-lua'
    local actions = require 'fzf-lua.actions'
    local path = require 'fzf-lua.path'

    fzf.setup {
      winopts = {
        height = 0.9,
        width = 0.9,
        border = 'single',
        hl = {
          normal = 'NormalFloat',
        },
      },
      fzf_opts = {
        ['--info'] = 'default',
      },
      keymap = {
        builtin = {
          ['<C-j>'] = 'preview-page-down',
          ['<C-k>'] = 'preview-page-up',
          ['<C-l>'] = 'toggle-preview',
        },
        fzf = {
          -- fzf '--bind=' options
          ['ctrl-c'] = 'abort',
          ['ctrl-u'] = 'unix-line-discard',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['ctrl-l'] = 'toggle-preview',
          ['ctrl-j'] = 'preview-down',
          ['ctrl-k'] = 'preview-up',
        },
      },
      actions = {
        files = {
          -- providers that inherit these actions:
          --   files, git_files, git_status, grep, lsp, oldfiles,
          --   quickfix, loclist, tags, btags, args
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-x'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          ['ctrl-q'] = actions.file_sel_to_qf,
          ['ctrl-r'] = function(selected, opts)
            local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
            vim.cmd 'vsplit'
            vim.cmd('Fern . -reveal=' .. vim.fn.fnameescape(entry.path))
          end,
        },
      },
      previewers = {
        git_diff = {
          pager = 'delta --width=$FZF_PREVIEW_COLUMNS',
        },
      },
      grep = {
        rg_glob = true,
      },
      file_icon_padding = ' ',
    }

    fzf.project_mru = setup_project_mru()
    fzf.templates = setup_template()
    fzf.grep_fern_dir = setup_grep_fern_dir()

    vim.lsp.handlers['textDocument/definition'] = function()
      fzf.lsp_definitions { jump_to_single_result = true }
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.handlers['textDocument/references'] = function() fzf.lsp_finder() end
  end,
}
