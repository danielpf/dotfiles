-- Set lualine as statusline
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
    lualine_c = {{'filename', file_status = true, path = 2}},
    lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'filetype', 'encoding', 'fileformat'},
    lualine_z = {'mode'}
  },
}
