UsePlugin 'fzf'
UsePlugin 'fzf.vim'

" [Commands] --expect expression for directly executing the command
" let g:fzf_commands_expect = 'alt-enter,ctrl-x'
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
let g:fzf_preview_window = 'right:50%'

command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?')
\ : fzf#vim#with_preview(),
\ <bang>0)

command! -bang -nargs=? -complete=dir Files
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
