return {
  'kana/vim-textobj-user',
  event = 'ModeChanged',
  dependencies = {
    { 'sgur/vim-textobj-parameter' },
    { 'kana/vim-textobj-entire' },
    { 'kana/vim-textobj-indent' },
    { 'kana/vim-textobj-line' },
    { 'glts/vim-textobj-comment' },
  },
  config = function()
    vim.cmd [[
function! LinewiseRoundedTO()
  return v:lua.require('plug.ex.textobj').linewise_bracket('(', ')')
endfunction
function! LinewiseBraceTO()
  return v:lua.require('plug.ex.textobj').linewise_bracket('{', '}')
endfunction
function! LinewiseSquareTO()
  return v:lua.require('plug.ex.textobj').linewise_bracket('\[', '\]')
endfunction
function! CommentChunkTO()
  return v:lua.require('plug.ex.textobj').comment_chunk()
endfunction
]]

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
  end,
}
