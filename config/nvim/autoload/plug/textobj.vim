function! plug#textobj#setup() abort
endfunction

function! plug#textobj#config() abort
  call textobj#user#plugin('underscore', {
  \   'a': {
  \     'select': 'a_',
  \     '*pattern*': '_[^_]*_'
  \   },
  \   'i': {
  \     'select': 'i_',
  \     '*pattern*': '_\zs[^_]\+\ze_'
  \   },
  \ })

  call textobj#user#plugin('space', {
  \   'a': {
  \     'pattern': '[[:blank:]　]\+',
  \     'select': ['a<Space>'],
  \   },
  \   'i': {
  \     'pattern': ' \+',
  \     'select': ['i<Space>'],
  \   },
  \ })
endfunction
