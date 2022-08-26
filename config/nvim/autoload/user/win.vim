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

" @param string direction: 'h', 'j', 'k', 'l'
function! user#win#resize(direction) abort
  if index(['h', 'j', 'k', 'l'], a:direction) == -1
    echoerr "user#win#resize(): invalid direction '".a:direction."'"
    return
  endif
  let winpos = win_screenpos(0)
  let win_first_line_pos = winpos[0]
  let win_first_col_pos = winpos[1]

  " if tabline is shown, first line pos is 2
  let is_top = win_first_line_pos == 1 || win_first_line_pos == 2
  let is_bottom = win_first_line_pos + winheight(0) + &cmdheight >= &lines
  " let is_leftmost = win_first_col_pos == 1
  let is_rightmost = win_first_col_pos - 1 + winwidth(0) == &columns

  let cmds = {
        \ 'h': is_rightmost ? '>' : '<',
        \ 'l': is_rightmost ? '<' : '>',
        \ 'k': is_bottom && !is_top ? '+' : '-',
        \ 'j': is_bottom && !is_top ? '-' : '+',
        \ }

  exe 'wincmd ' . cmds[a:direction]
endfunction
