if index(getcompletion('', 'color'), g:colorscheme) == -1
  finish
endif

MyAutocmd ColorScheme *
\   highlight Normal          ctermbg=none guibg=none
\ | highlight EndOfBuffer     ctermbg=none guibg=none
\ | highlight LineNr          ctermbg=none guibg=none
\ | highlight CursorLineNr    ctermbg=none guibg=none
\ | highlight SignColumn      ctermbg=none guibg=none
\ | highlight GitGutterAdd    ctermbg=none guibg=none
\ | highlight GitGutterChange ctermbg=none guibg=none
\ | highlight GitGutterDelete ctermbg=none guibg=none
\ | highlight VertSplit       ctermfg=none guifg=none
\ | highlight clear DiffAdd
\ | highlight clear DiffDelete
\ | highlight clear DiffChange
\ | highlight clear DiffText


if g:colorscheme ==# 'iceberg'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#45493e               |
  \ highlight DiffDelete guibg=#53343b guifg=#53343b |
  \ highlight DiffChange guibg=#384851               |
  \ highlight DiffText   guibg=#0f324d gui=bold
elseif g:colorscheme ==# 'nord'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#2e4159               |
  \ highlight DiffText   guibg=#19283b gui=bold
elseif g:colorscheme ==# 'hydrangea'
  MyAutocmd ColorScheme *
  \ highlight ColorColumn guibg=#421424              |
  \ highlight GitGutterChange guifg=#996ddb          |
  \ highlight DiffAdd    guibg=#043a4a               |
  \ highlight DiffDelete guibg=#4f0539 guifg=#4f0539 |
  \ highlight DiffChange guibg=#2a4275               |
  \ highlight DiffText   guibg=#0b2e7a gui=bold
elseif g:colorscheme ==# 'mirodark'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#002529               |
  \ highlight DiffDelete guibg=#2e012b guifg=#2e012b |
  \ highlight DiffChange guibg=#14113d               |
  \ highlight DiffText   guibg=#000000 gui=bold
elseif g:colorscheme ==# 'gotham'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#043327               |
  \ highlight DiffDelete guibg=#451714 guifg=#451714 |
  \ highlight DiffChange guibg=#0a3749               |
  \ highlight DiffText   guibg=#091f2e gui=bold
elseif g:colorscheme ==# 'farout'
  MyAutocmd ColorScheme *
  \ highlight CursorLineNr guifg=#F2DDBC             |
  \ highlight CursorLine   guibg=#2F1D1A             |
  \ highlight ColorColumn  guibg=#2F1D1A             |
  \ highlight DiffAdd    guibg=#142903               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#302c01 gui=bold
elseif g:colorscheme ==# 'mellow'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#362d02 gui=bold
elseif g:colorscheme ==# 'monotone'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#333332               |
  \ highlight DiffDelete guibg=#333333 guifg=#333333 |
  \ highlight DiffChange guibg=#333333               |
  \ highlight DiffText   guibg=#222222 gui=bold
  " \ highlight DiffAdd    guibg=#3e5432               |
  " \ highlight DiffDelete guibg=#693e30 guifg=#693e30 |
  " \ highlight DiffChange guibg=#3a455c               |
  " \ highlight DiffText   gui=inverse,bold
endif

exe 'colorscheme ' . g:colorscheme

if g:colorscheme ==# 'mirodark'
  let g:lightline.colorscheme = 'apprentice'
elseif g:colorscheme ==# 'monotone'
  let g:lightline.colorscheme = 'jellybeans'
else
  let g:lightline.colorscheme = g:colorscheme
endif

call lightline#init()
call lightline#colorscheme()
call lightline#update()
