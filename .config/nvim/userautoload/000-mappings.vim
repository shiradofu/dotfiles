cabbrev h vertical topleft h

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>

inoremap <C-b> <left>
inoremap <C-f> <right>

cnoremap <C-b> <left>
cnoremap <C-f> <right>
cnoremap <C-n> <down>
cnoremap <C-p> <up>
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-d> <del>

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
nnoremap <silent> s. :<C-u>bn<CR>
nnoremap <silent> s, :<C-u>bp<CR>
nnoremap <silent> <BS> :<C-u>q<CR>
nnoremap <silent> s<BS> :<C-u>tabclose<CR>

if IsPlugInstalled('vim-easymotion')
  nmap <Space> <Plug>(easymotion-overwin-f)
endif

if IsPlugInstalled('fzf') && IsPlugInstalled('fzf.vim')
  nnoremap <silent> so :<C-u>Files<CR>
  nnoremap <silent> su :<C-u>History<CR>
  nnoremap <silent> s; :<C-u>History:<CR>
  nnoremap <silent> s/ :<C-u>History/<CR>
  nnoremap <silent> sa :<C-u>Snippets<CR>
  nnoremap <silent> sc :<C-u>Commits<CR>
  nnoremap <silent> sC :<C-u>Colors<CR>
  "nnoremap <silent> sf :<C-u>Rgの拡張子指定<CR>
  "nnoremap <silent> si :<C-u>gitに含まれないファイルを含めた検索<CR>
endif

if IsPlugInstalled('vim-submode')
  call submode#enter_with('bufmove', 'n', '', 's>', '3<C-w>>')
  call submode#enter_with('bufmove', 'n', '', 's<', '3<C-w><')
  call submode#enter_with('bufmove', 'n', '', 's+', '3<C-w>+')
  call submode#enter_with('bufmove', 'n', '', 's-', '3<C-w>-')
  call submode#map('bufmove', 'n', '', '>', '3<C-w>>')
  call submode#map('bufmove', 'n', '', '<', '3<C-w><')
  call submode#map('bufmove', 'n', '', '+', '3<C-w>+')
  call submode#map('bufmove', 'n', '', '-', '3<C-w>-')
endif

if IsPlugInstalled('caw.vim')
  nmap g/ <Plug>(caw:hatpos:toggle)
  xmap g/ <Plug>(caw:hatpos:toggle)
  " nmap g/ <Plug>(caw:box:comment)
  " xmap g/ <Plug>(caw:box:comment)
endif

if IsPlugInstalled('open-browser.vim')
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endif

if IsPlugInstalled('open-browser-github.vim')
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endif

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

function! s:MoveToNewTab()
    tab split
    tabprevious

    if winnr('$') > 1
        close
    elseif bufnr('$') > 1
        buffer #
    endif

    tabnext
  endfunction
