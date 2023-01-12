require('rose-pine').setup({
  --- @usage 'main' | 'moon'
  dark_variant = 'main',
  bold_vert_split = false,
  dim_nc_background = false,
  disable_background = false,
  disable_float_background = false,
  disable_italics = false,

  --- @usage string hex value or named color from rosepinetheme.com/palette
  groups = {
    background = 'base',
    panel = 'surface',
    border = 'highlight_med',
    comment = 'muted',
    link = 'iris',
    punctuation = 'subtle',

    error = 'love',
    hint = 'iris',
    info = 'foam',
    warn = 'gold',

    headings = {
      h1 = 'iris',
      h2 = 'foam',
      h3 = 'rose',
      h4 = 'gold',
      h5 = 'pine',
      h6 = 'foam',
    }
    -- or set all headings at once
    -- headings = 'subtle'
  },

  -- Change specific vim highlight groups
  highlight_groups = {
    ColorColumn = { bg = 'rose' }
  }
})

-- set background transparent
function ColorMyPencils()
  local color = color or "rose-pine"
  vim.cmd("colorscheme " .. color);
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" } );
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } );
end
ColorMyPencils()

-- set colorscheme after options
vim.cmd('colorscheme dracula');


vim.cmd("hi CursorLine  guibg=#373A4B") -- highlighting of the line you are in
vim.cmd("hi ColorColumn  guibg=#373A4B")
vim.cmd("hi CursorLineNr  guifg=#ffb86c")
vim.cmd("hi VertSplit  guibg=#6272a4")

vim.cmd("hi NotifyBackground  guibg=#6272a4")
