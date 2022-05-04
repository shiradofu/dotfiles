function! plug#scratch#hook_add() abort
  let g:scratch_autohide = 0
  let g:scratch_height = 0.3
  let g:scratch_top = 1
  let g:scratch_horizontal = 1
  let g:scratch_filetype = 'markdown'
  let g:scratch_persistence_file = '.scratch.md'
  let g:scratch_no_mappings = 1
  autocmd InsertLeave,TextChanged __Scratch__ execute ':silent w! ' . g:scratch_persistence_file
endfunction
