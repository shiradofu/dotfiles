nnoremap <silent> s0 :<C-u>call dein#recache_runtimepath()<CR>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
command! -nargs=1 H vertical leftabove help <args>

" window commands
nnoremap s <Nop>
nnoremap <silent> sj <C-w>j
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl :<C-u>call GoToRightWindow()<CR>
nnoremap <silent> sh :<C-u>call GoToLeftWindow()<CR>
nnoremap <silent> sJ <C-w>J
nnoremap <silent> sK <C-w>K
nnoremap <silent> sL <C-w>L
nnoremap <silent> sH <C-w>H
nnoremap <silent> sn gt
nnoremap <silent> sp gT
nnoremap <silent> sr <C-w>r
nnoremap <silent> sg <C-w>_<C-w>\|
nnoremap <silent> ss <C-w>=
nnoremap <silent> sN :<C-u>bn<CR>
nnoremap <silent> sP :<C-u>bp<CR>
nnoremap <silent> <BS> :<C-u>q<CR>
nnoremap <silent> s<BS> :<C-u>tabclose<CR>

function! GoToLeftWindow()
  let l:current = expand("%:p")
  execute "normal \<C-w>h"
  if l:current == expand("%:p")
    execute "normal \<C-w>W"
  endif
endfunction

function! GoToRightWindow()
  let l:current = expand("%:p")
  execute "normal \<C-w>l"
  if l:current == expand("%:p")
    execute "normal \<C-w>w"
  endif
endfunction
