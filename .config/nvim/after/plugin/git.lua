local k = require("danielf.keymap")

-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    --add          = { text = 'G+' },
    --change       = { text = 'GM' },
    --delete       = { text = 'G-' },
    --topdelete    = { text = 'G^' },
    --changedelete = { text = 'G~' },
    --untracked    = { text = 'GU', hl = 'GitSignsAdd', numhl='GitSignsAddNr' , linehl='GitSignsAddLn'    }
    --thin: │
    add          = { hl = 'GitSignsAdd'   , text = '▌', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
    change       = { hl = 'GitSignsChange', text = '▌', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '-', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
    untracked    = { hl = 'GitSignsAdd'   , text = '?', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    k.nnoremap(k.lead..'gR', gs.reset_hunk, {buffer = bufnr})
    k.nnoremap(k.lead..'gh', gs.preview_hunk, {buffer = bufnr})
  end
}

-- fugitive
k.nnoremap("<leader>gs", function() vim.cmd("Git") end);
k.nnoremap("<leader>gb", function() vim.cmd("Git blame") end);
k.nnoremap("<leader>gd", function() vim.cmd("Gdiffsplit!") end);

local log_opts = "--graph --abbrev-commit"
--log_opts = log_opts .. " --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
k.nnoremap("<leader>gl", function() vim.cmd("Git log "..log_opts.." %") end);
