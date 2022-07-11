augroup MyColorScheme
  autocmd!

  autocmd ColorScheme iceberg
  \ highlight DiffAdd    guibg=#45493e               |
  \ highlight DiffDelete guibg=#53343b guifg=#53343b |
  \ highlight DiffChange guibg=#384851               |
  \ highlight DiffText   guibg=#0f324d gui=bold

  autocmd ColorScheme nord
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#2e4159               |
  \ highlight DiffText   guibg=#19283b gui=bold

  autocmd ColorScheme hydrangea
  \ highlight ColorColumn guibg=#421424              |
  \ highlight GitGutterChange guifg=#996ddb          |
  \ highlight DiffAdd    guibg=#043a4a               |
  \ highlight DiffDelete guibg=#4f0539 guifg=#4f0539 |
  \ highlight DiffChange guibg=#2a4275               |
  \ highlight DiffText   guibg=#0b2e7a gui=bold

  autocmd ColorScheme mirodark
  \ highlight DiffAdd    guibg=#002529               |
  \ highlight DiffDelete guibg=#2e012b guifg=#2e012b |
  \ highlight DiffChange guibg=#14113d               |
  \ highlight DiffText   guibg=#000000 gui=bold

  autocmd ColorScheme gotham
  \ highlight DiffAdd    guibg=#043327               |
  \ highlight DiffDelete guibg=#451714 guifg=#451714 |
  \ highlight DiffChange guibg=#0a3749               |
  \ highlight DiffText   guibg=#091f2e gui=bold

  autocmd ColorScheme farout
  \ highlight CursorLineNr guifg=#F2DDBC             |
  \ highlight CursorLine   guibg=#2F1D1A             |
  \ highlight ColorColumn  guibg=#2F1D1A             |
  \ highlight DiffAdd    guibg=#142903               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#302c01 gui=bold

  autocmd ColorScheme mellow
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#362d02 gui=bold
augroup END

" function! colorscheme#get() abort
"   " カラースキームの変更をgit管理しないように切り出している
"   exe 'source ' . g:config_dir . '/_color.vim'
"   let g:colorscheme = get(g:, 'colorscheme', 'default')
" endfunction

function! colorscheme#set() abort
  let name = !empty($COLORSCHEME) ? $COLORSCHEME : 'default'

  " l:name が有効なカラースキーム名かどうか検証
  if index(getcompletion('', 'color'), l:name) == -1
    exe 'echoerr "invalid colorscheme name: ' . l:name . '"'
    l:name = 'default'
  endif

  exe 'colorscheme ' . l:name

  if l:name ==# 'nightfox'
    let g:lightline.colorscheme = 'apprentice'
  elseif l:name ==# 'mirodark'
    let g:lightline.colorscheme = 'apprentice'
  else
    let g:lightline.colorscheme = l:name
  endif

  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction
