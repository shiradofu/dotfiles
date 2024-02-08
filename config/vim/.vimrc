if empty("$XDG_CACHE_HOME")
    let $XDG_CACHE_HOME="$HOME/.cache"
endif
set directory=$XDG_CACHE_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim/backup,~/,/tmp
set undodir=$XDG_CACHE_HOME/vim/undo,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo

nnoremap <expr> <BS> &diff ? ':<C-u>qa<CR>' : ':<C-u>q<CR>'
nnoremap <silent> g<BS> :<C-u>qa<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
