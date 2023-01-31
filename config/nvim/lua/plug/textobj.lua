local util = require 'user.util'
local comment = require 'user.comment'

local M = {}

function M.linewise_bracket(opening, closing)
  local cur = vim.api.nvim_win_get_cursor(0)
  local row = cur[1] - 1
  local col = cur[2]
  local char = util.get_line_content(row):sub(col + 1, col + 1)
  local flags = char == closing and 'cW' or 'W'

  vim.fn.searchpair(opening, '', closing, flags)
  local closing_pos = vim.fn.getpos '.'
  vim.cmd 'normal! %'
  local opening_pos = vim.fn.getpos '.'
  return { 'V', opening_pos, closing_pos }
end

local function check_comment_chunk()
  local n = util.file_row_num.cursor()
  local l = util.get_line_content(n)
  return comment.is_line_comment(n) or l:find '^%s*$'
end
function M.comment_chunk()
  local start_pos, end_pos
  if not check_comment_chunk() then return 0 end
  for i = 1, 1000 do
    vim.cmd 'normal! k'
    if not check_comment_chunk() then
      vim.cmd 'normal! j'
      start_pos = vim.fn.getpos '.'
      vim.cmd('normal! ' .. i .. 'jk')
      break
    end
  end
  for _ = 1, 1000 do
    vim.cmd 'normal! j'
    if not check_comment_chunk() then
      vim.cmd 'normal! k'
      end_pos = vim.fn.getpos '.'
    end
  end
  return { 'V', start_pos, end_pos }
end

vim.cmd [[
function! LinewiseRoundedTO()
  return v:lua.require('plug.textobj').linewise_bracket('(', ')')
endfunction
function! LinewiseBraceTO()
  return v:lua.require('plug.textobj').linewise_bracket('{', '}')
endfunction
function! LinewiseSquareTO()
  return v:lua.require('plug.textobj').linewise_bracket('\[', '\]')
endfunction
function! CommentChunkTO()
  return v:lua.require('plug.textobj').comment_chunk()
endfunction
]]

function M.config()
  vim.fn['textobj#user#plugin']('underscore', {
    i = {
      select = 'i_',
      pattern = [[_\zs[^_]\+\ze_]],
    },
    a = {
      select = 'a_',
      pattern = '_[^_]*_',
    },
  })

  vim.fn['textobj#user#plugin']('space', {
    i = {
      select = 'i<Space>',
      pattern = [[ \+]],
    },
    a = {
      select = 'a<Space>',
      pattern = [=[[[:blank:]　]\+]=],
    },
  })

  vim.fn['textobj#user#plugin']('bracket', {
    rounded = {
      pattern = { '(', ')' },
      ['select-i'] = 'ir',
      ['select-a'] = 'ar',
    },
    brace = {
      pattern = { '{', '}' },
      ['select-i'] = 'ib',
      ['select-a'] = 'ab',
    },
    square = {
      pattern = { [[\[]], [=[\]]=] },
      ['select-i'] = 'is',
      ['select-a'] = 'as',
    },
    angle = {
      pattern = { '<', '>' },
      ['select-i'] = 'ia',
      ['select-a'] = 'aa',
    },
  })

  vim.fn['textobj#user#plugin']('linewise', {
    rounded = {
      ['select-a'] = 'aR',
      ['select-a-function'] = 'LinewiseRoundedTO',
    },
    brace = {
      ['select-a'] = 'aB',
      ['select-a-function'] = 'LinewiseBraceTO',
    },
    square = {
      ['select-a'] = 'aS',
      ['select-a-function'] = 'LinewiseSquareTO',
    },
  })

  vim.fn['textobj#user#plugin']('commentchunk', {
    ['-'] = {
      ['select-a'] = 'aC',
      ['select-a-function'] = 'CommentChunkTO',
    },
  })
end

return M
