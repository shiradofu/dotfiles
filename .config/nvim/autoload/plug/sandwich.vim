function! plug#sandwich#hook_add() abort
  let g:sandwich_no_default_key_mappings = 1
  let g:operator_sandwich_no_default_key_mappings = 1
  let g:textobj_sandwich_no_default_key_mappings = 1

  omap in <Plug>(textobj-sandwich-auto-i)
  xmap in <Plug>(textobj-sandwich-auto-i)
  omap an <Plug>(textobj-sandwich-auto-a)
  xmap an <Plug>(textobj-sandwich-auto-a)

  omap iv <Plug>(textobj-sandwich-query-i)
  xmap iv <Plug>(textobj-sandwich-query-i)
  omap av <Plug>(textobj-sandwich-query-a)
  xmap av <Plug>(textobj-sandwich-query-a)
endfunction

function! plug#sandwich#hook_post_source() abort
  runtime macros/sandwich/keymap/surround.vim
  let g:sandwich#recipes += [
  \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1,
  \    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
  \
  \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1,
  \    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
  \
  \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1,
  \    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
  \
  \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1,
  \    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
  \    'action': ['delete'], 'input': ['{']},
  \
  \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1,
  \    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
  \    'action': ['delete'], 'input': ['[']},
  \
  \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1,
  \    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
  \    'action': ['delete'], 'input': ['(']},
  \ ]
endfunction
