local W = {}

function W.close()
  if not pcall(vim.api.nvim_win_close, false) then pcall(vim.cmd.quit) end
end

---@param kind 'tab'|'win'
---@param tag string
---@param callback string|function
function W.reuse(kind, tag, callback)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.tbl_get(vim.w[win], tag) then
      return vim.api.nvim_set_current_win(win)
    end
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.tbl_get(vim.t[tab], tag) then
      return vim.api.nvim_set_current_tabpage(tab)
    end
  end
  if type(callback) == 'string' then vim.cmd(callback) end
  if type(callback) == 'function' then callback() end
  if kind == 'tab' then vim.t[tag] = true end
  if kind == 'win' then vim.w[tag] = true end
end

function W.move()
  if vim.v.count == 0 then
    vim.cmd 'wincmd T'
  else
    local tabpagenr = vim.v.count
    local bufnr = vim.api.nvim_get_current_buf()
    local win_ids = vim.api.nvim_tabpage_list_wins(tabpagenr)
    local last_win_id = win_ids[#win_ids]
    vim.api.nvim_win_close(0, true)
    vim.api.nvim_set_current_win(last_win_id)
    vim.cmd('vert sbuffer ' .. bufnr)
  end
end

function W.tabclose()
  local cmd = #vim.api.nvim_list_tabpages() == 1 and 'qall' or 'tabclose'
  vim.cmd(cmd)
end

---@param direction 'h'|'j'|'k'|'l'
function W.resize(direction)
  local winpos = vim.fn.win_screenpos(0)
  local win_first_line_pos = winpos[1]
  local win_first_col_pos = winpos[2]

  -- if tabline is shown, first line pos is 2
  local is_top = win_first_line_pos == 1 or win_first_line_pos == 2
  local is_bottom = win_first_line_pos + vim.fn.winheight(0) + vim.o.cmdheight
    >= vim.o.lines
  -- let is_leftmost = win_first_col_pos == 1
  local is_rightmost = win_first_col_pos - 1 + vim.fn.winwidth(0)
    == vim.o.columns

  local cmds = {
    h = is_rightmost and '2>' or '2<',
    l = is_rightmost and '2<' or '2>',
    k = is_bottom and not is_top and '+' or '-',
    j = is_bottom and not is_top and '-' or '+',
  }

  vim.cmd('wincmd ' .. cmds[direction])
end

function W.focus_float()
  local win_ids = vim.tbl_filter(function(win_id)
    local config = vim.api.nvim_win_get_config(win_id)
    return config.relative ~= '' and config.focusable
  end, vim.api.nvim_tabpage_list_wins(0))
  vim.api.nvim_set_current_win(win_ids[1])
end

return W
