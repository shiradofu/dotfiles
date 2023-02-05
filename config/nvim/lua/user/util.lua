local U = {}

function U.feedkeys(key, mode)
  key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(key, mode, false)
end

-- 0-based row number
U.file_row_num = {
  first = function() return 0 end,
  last = function(buf) return vim.api.nvim_buf_line_count(buf or 0) - 1 end,
  cursor = function() return vim.api.nvim_win_get_cursor(0)[1] - 1 end,
}
U.win_row_num = {
  first = function() return 0 end,
  last = function(buf) return vim.api.nvim_win_get_height(buf or 0) - 1 end,
  cursor = function() return vim.fn.winline() - 1 end,
}

---@param file_row_num number
---@param buf number|nil
---@return string
function U.get_line_content(file_row_num, buf)
  if not type(file_row_num) == 'number' then return '' end
  local line = vim.api.nvim_buf_get_lines(
    buf or 0,
    file_row_num,
    file_row_num + 1,
    false
  )[1]
  return line or ''
end

U.js_family =
  { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

U.fzf_fd_noignore =
  '--color=never --type f --hidden --follow --exclude .git --no-ignore-vcs'
U.fzf_rg_noignore =
  '--column --line-number --no-heading --color=always --smart-case --max-columns=512 --no-ignore-vcs'

return U
