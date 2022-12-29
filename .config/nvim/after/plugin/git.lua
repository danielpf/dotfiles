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
nnoremap("<leader>gd", function() vim.cmd("Gdiffsplit!") end);

local log_opts = "--graph --abbrev-commit"
--log_opts = log_opts .. " --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
nnoremap("<leader>gl", function() vim.cmd("Git log "..log_opts.." %") end);
