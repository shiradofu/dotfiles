" https://github.com/mtth/scratch.vim

if get(g:, 'user#scratch#loaded', 0) | finish | endif

augroup ScratchFloat | autocmd! | augroup END

let g:scratch_filetype = 'markdown'
let g:scratch_persistence_file = '.scratch-vim.md'

function! user#scratch#open() abort
  if bufname() ==# '__Scratch__' | return | endif
  let s:home = win_findbuf(bufnr())[0]
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left,
  \ 'width': width, 'height': height, 'style': 'minimal'}

  let top = "┌" . repeat("─", width - 2) . "┐"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "└" . repeat("─", width - 2) . "┘"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let s:borderbuf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:borderbuf, 0, -1, v:true, lines)
  call nvim_open_win(s:borderbuf, v:true, opts)
  set winhl=Normal:Floating
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  let scr_bufnr = bufnr('__Scratch__')
  if scr_bufnr == -1
    call nvim_buf_set_name(bufnr('%'), '__Scratch__')
    execute 'setlocal filetype=' . g:scratch_filetype
    setlocal nofoldenable
    if strlen(g:scratch_persistence_file) > 0
      if filereadable(fnamemodify(g:scratch_persistence_file, ':p'))
        let cpo = &cpo | set cpo-=a
        execute ':r ' . g:scratch_persistence_file
        let &cpo = cpo
        execute 'normal! ggdd'
      endif
    endif
    autocmd ScratchFloat WinLeave <buffer> call user#scratch#close()
  else
    call nvim_win_set_buf(win_getid(winnr()), scr_bufnr)
  endif
  call user#scratch#mapping()
  setlocal conceallevel=0
endfunction

function! user#scratch#close() abort
  if strlen(g:scratch_persistence_file) > 0
    execute ':w! ' . g:scratch_persistence_file
  endif
  close
  exe 'bwipeout ' . s:borderbuf
endfunction

function! user#scratch#leave() abort
  if s:home
    call win_gotoid(s:home)
  else
    wincmd w
  endif
endfunction

function! user#scratch#mapping() abort
  nnoremap <silent> <buffer> <BS>  :<C-u>call user#scratch#leave()<CR>
  nnoremap <silent> <buffer> <C-h> :<C-u>call user#scratch#leave()<CR>
  nnoremap <silent> <buffer> <C-j> :<C-u>call user#scratch#leave()<CR>
  nnoremap <silent> <buffer> <C-k> :<C-u>call user#scratch#leave()<CR>
  nnoremap <silent> <buffer> <C-l> :<C-u>call user#scratch#leave()<CR>
endfunction

let g:user#scratch#loaded = 1
