" https://koturn.hatenablog.com/entry/2018/02/12/140000
function! user#win#goto_or(bufname, cmd_if_not) abort
  let bnr = bufnr(a:bufname)
  if bnr == -1
    exe a:cmd_if_not
    return
  endif
  let wids = win_findbuf(bnr)
  if empty(wids)
    exe a:cmd_if_not
    return
  else
    call win_gotoid(wids[0])
  endif
endfunction

function user#win#move(count)
  if a:count ==# 0
    wincmd T
  else
    call s:move_buf_to_tabpage(a:count)
  endif
endfunction

" windowを指定したタブに移動する
function! s:move_buf_to_tabpage(tabpagenr)
  let bufnr = bufnr() | close
  call win_gotoid(win_getid(tabpagewinnr(a:tabpagenr, '$'), a:tabpagenr))
  exe 'vert sbuffer ' . bufnr
endfunction

" windowを閉じたらwinnrを基準に1つ前のwindowに移動する
function! user#win#quit()
  try
    " float window 上、または window が1つしかない場合は単純に quit
    if s:is_float(win_getid()) || range(1, tabpagewinnr(tabpagenr(), '$')) ==# [1]
      quit
    else
      let close_winnr = winnr()
      wincmd p
      exe close_winnr . 'wincmd q'
      " let dest_winnr = close_winnr ==# 1 ? 2 : (close_winnr - 1)
      " exe dest_winnr . 'wincmd w'
    endif
  catch /^Vim\%((\a\+)\)\=:E5601/
    " タブ内にwindow1つ+floating windowが表示されているとき
    call user#win#tabclose()
  catch /^Vim\%((\a\+)\)\=:E444/
    call user#win#tabclose()
  endtry
endfunction

function! user#win#tabclose() abort
  exe tabpagenr('$') == 1 ? "qall" : "tabclose"
endfunction

" Copy of coc#float#jump
" https://github.com/neoclide/coc.nvim/blob/cd03c8be8716f7352fbec2269cad627819aadbb3/autoload/coc/float.vim#L27
function! user#win#focus_float() abort
  let winids = s:get_float_win_list()
  if !empty(winids)
    call win_gotoid(winids[0])
  endif
endfunction
function! s:get_float_win_list() abort
  let res = []
  for i in range(1, winnr('$'))
    let id = win_getid(i)
    if !s:is_float(id)| continue | endif
    " ignore border & button window & others
    " depends on coc impl
    " if !getwinvar(id, 'float', 0)
    "   continue
    " endif
    call add(res, id)
  endfor
  return res
endfunction

function! s:is_float(winid) abort
  let config = nvim_win_get_config(a:winid)
  return !empty(config) && !empty(config['relative'])
endfunction

