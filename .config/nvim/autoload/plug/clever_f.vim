function! plug#clever_f#setup() abort
  let g:clever_f_not_overwrites_standard_mappings = 1

  augroup MyCleverF
    autocmd!
    autocmd ColorScheme * call plug#clever_f#hl()
  augroup END
  call plug#clever_f#hl()

  let g:clever_f_across_no_line = 1
  let g:clever_f_mark_char = 1
  let g:clever_f_mark_direct = 1
  let g:clever_f_mark_char_color = 'CleverF'
  let g:clever_f_mark_direct_color = 'CleverF'
endfunction

function plug#clever_f#hl() abort
  highlight CleverF guifg=#ff0000 gui=underline
endfunction
