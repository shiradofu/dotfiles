local utils = require 'nvim-treesitter-playground.utils'

local M = {}

local function feedkeys(key, mode)
  key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(key, mode, false)
end

---@param relative number | nil
---@return number | nil
local function get_row_num(relative)
  relative = relative or 0
  local row = vim.api.nvim_win_get_cursor(0)[1]
  row = row - 1 + relative
  if row < 0 then
    return nil
  end
  return row
end

---@param row number | nil
---@return string
local function get_line(row)
  if not row then
    return ''
  end
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  return line or ''
end

---@param row number | nil
---@return number | nil
local function get_first_non_blank_col_num(row)
  if not row then
    return nil
  end
  local col = get_line(row):find '%S'
  if not col then
    return nil
  end
  return col - 1
end

---与えられた位置の文字のハイライトがコメントかどうかを判定
---@param bufnr number
---@param row number | nil
---@param col number | nil
---@return boolean
local function is_comment(bufnr, row, col)
  if not row or not col then
    return false
  end
  local results = utils.get_hl_groups_at_position(bufnr, row, col)
  for _, hl in pairs(results) do
    if hl.capture == 'comment' then
      return true
    end
  end
  if vim.bo[bufnr].syntax ~= '' then
    for _, syntax_id in ipairs(vim.fn.synstack(row, col)) do
      local syntax_group_id = vim.fn.synIDtrans(syntax_id)
      local sytnax_group_name = vim.fn.synIDattr(syntax_group_id, 'name')
      if sytnax_group_name == 'Comment' then
        return true
      end
    end
  end
  return false
end

---与えられた行が commentstring から始まっているかどうかを判定
---なぜか is_comment がうまく機能しない時があるので補助的に使用
---(php の一行コメントなど)
---@param bufnr number
---@param row number | nil
---@return boolean
local function is_line_comment_with_commentstring(bufnr, row)
  local first_non_blank_chars = get_line(row):match '%S+'
  local commentstring = vim.bo[bufnr].commentstring
  if not first_non_blank_chars or not commentstring then
    return false
  end
  commentstring = commentstring:match('%S+'):gsub('%%s', '')
  return vim.startswith(first_non_blank_chars, commentstring)
end

---@param bufnr number
---@param relative number | nil
---@return boolean
local function is_line_comment(bufnr, relative)
  relative = relative or 0
  local row = get_row_num(relative)
  local col = get_first_non_blank_col_num(row)
  if is_comment(bufnr, row, col) then
    return true
  end
  if is_line_comment_with_commentstring(bufnr, row) then
    return true
  end
  return false
end

---複数行スタイルのコメントかどうかを判定する
---@param bufnr number
---@param relative number | nil
---@return boolean
local function is_multiline_comment(bufnr, relative)
  relative = relative or 0
  if not is_line_comment(bufnr, relative) then
    return false
  end
  local ft = vim.bo[bufnr].ft
  -- filetypeによるドキュメンテーションコメントのチェック
  if
    vim.tbl_contains({
      'c',
      'cpp',
      'php',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'java',
    }, ft)
  then
    local line = get_line(get_row_num(relative))
    if line:find '^%s*/%*%*?%s*' or line:find '^%s*%*%s*' then
      return true
    end
  end
  return false
end

---o または <CR> での改行後に実行。
---改行後、カーソル行にコメントが挿入されている場合、
---カーソル行のもう一つ次の行もコメントである(カーソル行が行コメントに挟まれている)、
---または改行前の行が複数行スタイルのコメント内部である場合を除き、
---改行後に挿入されるコメント文字を削除する。
function M.next()
  if get_line(get_row_num()):find '^%s*$' then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()

  if
    is_line_comment(bufnr)
    and not is_line_comment(bufnr, 1)
    and not is_multiline_comment(bufnr, -1)
  then
    feedkeys('<C-u>', 'n')
  end
end

---O での改行後に実行。
---改行後、カーソル行にコメントが挿入されている場合、
---カーソル行のもう一つ前の行もコメントである(カーソル行が行コメントに挟まれている)、
---または改行前の行が複数行スタイルのコメント内部である場合を除き、
---改行後に挿入されるコメント文字を削除する。
function M.prev()
  if get_line(get_row_num()):find '^%s*$' then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()

  if
    is_line_comment(bufnr)
    and not is_line_comment(bufnr, -1)
    and not is_multiline_comment(bufnr, 1)
  then
    feedkeys('<C-u>', 'n')
  end
end

return M
