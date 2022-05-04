" https://alpacat.com/blog/my-ddu-settings
function! plug#ddu#hook() abort
  call ddu#custom#patch_global({
  \   'ui': 'ff',
  \   'sources': [
  \     {
  \       'name': 'file_rec',
  \       'params': {
  \         'ignoredDirectories': ['.git', 'node_modules', 'vendor']
  \       }
  \     }
  \   ],
  \   'sourceOptions': {
  \     '_': {
  \       'matchers': ['matcher_fzf'],
  \     },
  \   },
  \   'filterParams': {
  \     'matcher_fzf': {
  \       'highlightMatched': 'Search',
  \     },
  \   },
  \   'kindOptions': {
  \     'file': {
  \       'defaultAction': 'open',
  \     },
  \   },
  \   'uiParams': {
  \     'ff': {
  \       'startFilter': v:true,
  \       'prompt': '> ',
  \       'split': 'floating',
  \     }
  \   },
  \ })
endfunction
