function! plug#quick_scope#setup() abort
  let g:qs_highlight_on_keys = ['f', 'F']
endfunction

function! plug#quick_scope#config() abort
  " let g:qs_accepted_chars += [
  " \ '`', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
  " \ '-', '_', '=', '+', '[', ']', '{', '}', '\', '|', ':', ';',
  " \ '"', "'", ',', '.', '<', '>', '/', '?']

  call plug#quick_scope#hl()
  augroup MyQuickScope
    autocmd!
    autocmd ColorScheme * call plug#quick_scope#hl()
  augroup END
endfunction

function plug#quick_scope#hl() abort
  highlight QuickScopePrimary guifg=#ff0000 gui=underline
endfunction
