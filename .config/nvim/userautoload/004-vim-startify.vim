UsePlugin 'vim-startify'

let g:startify_padding_left = 3
let g:startify_lists = [
\ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

let g:startify_files_number = 10

let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME
let g:startify_bookmarks = [
\ { 'c': s:config_home },
\ { 'v': s:config_home . '/nvim/init.vim' },
\ ]

let g:startify_fortune_use_unicode = 1
