-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = 'M' },
    delete       = { text = '-' },
    topdelete    = { text = '-?' },
    changedelete = { text = 'M-' },
    untracked    = { hl = 'GitSignsAdd'   , text = 'U', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    }
  }
}



