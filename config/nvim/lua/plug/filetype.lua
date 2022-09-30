require('filetype').setup {
  overrides = {
    complex = {
      ['.env.*'] = 'sh',
      ['phpstan.neon.dist'] = 'yaml',
    },
  },
}
