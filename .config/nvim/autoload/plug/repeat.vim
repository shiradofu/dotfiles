function plug#repeat#hook_post_source() abort
  " https://github.com/tpope/vim-repeat/issues/63
  function! RepeatWrap(command,count) abort
    let preserve = (get(g:, 'repeat_tick', -1) == b:changedtick)
    exe 'norm! ' . (a:count ? a:count : '') . a:command . (&foldopen =~# 'undo\|all' ? 'zv' : '')
    if preserve
      let g:repeat_tick = b:changedtick
    endif
  endfunction

  nnoremap <silent> u :<C-u>call RepeatWrap('u',v:count)<CR>
  nnoremap <silent> U :<C-u>call RepeatWrap('U',v:count)<CR>
  nnoremap <silent> <h-r> :<C-u>call RepeatWrap("\<Lt>C-R>",v:count)<CR>
endfunction
