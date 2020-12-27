UsePlugin 'vim-fugitive'

let g:nremap = { 's': '<Nop>' }
nnoremap <Plug>(fugitive) <Nop>
nmap <C-g> <Plug>(fugitive)
nnoremap <silent> <Plug>(fugitive)s :tabnew<CR><C-o>:<C-u>Gstatus<CR>
nnoremap <silent> <Plug>(fugitive)d :tabnew<CR><C-o>:<C-u>Gdiff<CR>
