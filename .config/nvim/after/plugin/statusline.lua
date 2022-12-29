-- set up highlighting
local function apply_hi_group(grp,s)
  return "%#"..grp.."#"..s.."%*"
end
-- lua bg 1 = 2c323c, lua bg 2 = 3e4452
vim.cmd("hi MyWinBarFg1 guibg=#3e4452 guifg=#abb2bf")
vim.cmd("hi MyWinBarFg2 guibg=#3e4452 guifg=#6272a4")
vim.cmd("hi Winbar      guibg=#3e4452")
-- set title on top of each window; %= → right align, %m → modified, ..
--"%="..
vim.opt.winbar=" "..apply_hi_group("MyWinBarFg2","%LL").." %m%r%w%h%* "..apply_hi_group("MyWinBarFg1","%f")


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
    lualine_a = {'location'},
    lualine_b = {'progress'},
    lualine_c = { my_statusline },
    --lualine_c = {{'filename', file_status = true}},   --, path = 2
    lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'filetype', 'encoding', 'fileformat'},
    lualine_z = {'mode'}
  },
}

