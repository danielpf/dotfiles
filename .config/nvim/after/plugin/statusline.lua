-- create highlight group
vim.cmd("hi MyWinBarColor guifg=#abb2bf guibg=#2c323c")
-- set title on top of each window; %= → right align, %m → modified, ..
vim.opt.winbar="%=%#LineNr#%LL%* %m%r%w%h%* %#MyWinBarColor#%f"

--- Set lualine as statusline

function my_statusline()
  return "["..vim.fn.getcwd().."]"
end

-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'location'},
    lualine_b = {'progress'},
    lualine_c = { my_statusline },
    --lualine_c = {{'filename', file_status = true}},   --, path = 2
    lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'filetype', 'encoding', 'fileformat'},
    lualine_z = {'mode'}
  },
}

