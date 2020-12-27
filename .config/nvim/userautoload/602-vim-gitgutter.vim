UsePlugin 'vim-gitgutter'

let g:gitgutter_sign_added = '‖'
let g:gitgutter_sign_modified = '‖'
let g:gitgutter_sign_removed = '‖'
let g:gitgutter_sign_modified_removed = '‖'
let g:gitgutter_sign_removed_first_line = '‖'
au myAu ColorScheme *
\   highlight GitGutterAdd    ctermfg=2  ctermbg=none
\ |	highlight GitGutterChange ctermfg=12 ctermbg=none
\ |	highlight GitGutterDelete ctermfg=1  ctermbg=none
\ |	highlight SignColumn      ctermfg=1  ctermbg=none
