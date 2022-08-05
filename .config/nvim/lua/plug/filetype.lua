require('filetype').setup {
  overrides = {
    complex = {
      ['.env.*'] = 'sh',
    },
  },
}
