-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add          = { text = 'G+' },
    change       = { text = 'GM' },
    delete       = { text = 'G-' },
    topdelete    = { text = 'G^' },
    changedelete = { text = 'G~' },
    untracked    = { text = 'GU', hl = 'GitSignsAdd', numhl='GitSignsAddNr' , linehl='GitSignsAddLn'    }
    --preview_config = {
    --  -- Options passed to nvim_open_win
    --  border = 'single',
    --  style = 'minimal',
    --  relative = 'cursor',
    --  row = 0,
    --  col = 1
    --}
  }
}

-- fugitive
local nnoremap = require("danielf.keymap").nnoremap;
nnoremap("<leader>gs", function() vim.cmd("Git") end);
nnoremap("<leader>gb", function() vim.cmd("Git blame") end);
