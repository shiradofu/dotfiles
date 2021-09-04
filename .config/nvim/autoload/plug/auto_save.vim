function plug#auto_save#hook_add() abort
  let g:auto_save = 1
  let g:auto_save_silent = 1
  let g:auto_save_presave_hook = 'ShouldAutoSave'

  function! ShouldAutoSave() abort
    if empty(execute('FindRoot'))
      let g:auto_save_abort = 1 | return
    endif
    if &filetype == 'gitcommit'
      let g:auto_save_abort = 1 | return
    endif
    if &filetype == 'qfreplace'
      let g:auto_save_abort = 1 | return
    endif
    if &filetype == 'fern-replacer'
      let g:auto_save_abort = 1 | return
    endif
  endfunction
  command! ShouldAutoSave :call ShouldAutoSave()
endfunction
