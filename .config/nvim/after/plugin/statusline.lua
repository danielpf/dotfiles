-- set up highlighting
local function apply_hi_group(grp,s)
  return "%#"..grp.."#"..s.."%*"
end
-- lua bg 1 = 2c323c, lua bg 2 = 3e4452
--vim.cmd("hi MyWinBarFg1 guibg=#3e4452 guifg=#abb2bf")
--vim.cmd("hi MyWinBarFg2 guibg=#3e4452 guifg=#6272a4")
--vim.cmd("hi Winbar      guibg=#3e4452")
vim.cmd("hi MyWinBarDark  guibg=#2c323c guifg=#abb2bf")
vim.cmd("hi MyWinBarLight guibg=#6272a4 guifg=#ffffff")
vim.cmd("hi Winbar        guibg=#6272a4")
-- set title on top of each window; %= → right align, %m → modified, ..
--"%="..
vim.opt.winbar=" "..apply_hi_group("MyWinBarLight","%LL").." | "..apply_hi_group("MyWinBarLight","%f").." %m%r%w%h%*"

--- Set lualine as statusline

local function my_statusline()
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
    lualine_a = {'branch'},
    lualine_b = { my_statusline },
    lualine_c = {'progress'},
    --lualine_c = {{'filename', file_status = true}},   --, path = 2
    lualine_x = {'diff'},
    lualine_y = {'filetype', 'encoding', 'fileformat'},
    lualine_z = {'mode'}
  },
}

