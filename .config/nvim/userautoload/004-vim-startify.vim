UsePlugin 'vim-startify'

let g:startify_custom_header = ''

let g:startify_padding_left = 3
let g:startify_files_number = 10
let g:startify_lists = [
\ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
let g:startify_bookmarks = [
\ { 'c': s:config_home },
\ { 'v': s:config_home . '/nvim/init.vim' },
\ { 'z': s:config_home . '/zsh/.zshrc' },
\ ]

let g:startify_fortune_use_unicode = 1

autocmd User Startified nmap <buffer> s <nop>
