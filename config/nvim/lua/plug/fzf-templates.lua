local core = require 'fzf-lua.core'
local config = require 'fzf-lua.config'
local path = require 'fzf-lua.path'

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
  previewer = config._default_previewer_fn,
  prompt = 'Templates{}> ',
  prompt_sep = '@',
  -- should use get_files_cmd in fzf-lua.files
  cmd = [[fd --color=never --type f --hidden --follow --exclude .git]],
  multiprocess = true,
  file_icons = true and config._has_devicons,
  color_icons = true,
  git_icons = false,
  find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
  rg_opts = "--color=never --files --hidden --follow -g '!.git'",
  fd_opts = '--color=never --type f --hidden --follow --exclude .git',
  _actions = function()
    local a = config.globals.actions.files
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
