function! plug#whitespace#setup() abort
  let g:better_whitespace_enabled = 1
  let g:strip_whitespace_on_save = 1
  let g:strip_whitespace_confirm = 0
  let g:strip_only_modified_lines = 1
  let g:show_spaces_that_precede_tabs = 1

  augroup MyBetterWhitespace
    autocmd!
    autocmd BufEnter * call plug#whitespace#hl()
  augroup END
  call plug#whitespace#hl()
endfunction

function plug#whitespace#hl() abort
  let hl = synIDattr(hlID('Error'),'fg')
  exe 'hi ExtraWhitespace guibg='.hl.' guifg='.hl
endfunction
