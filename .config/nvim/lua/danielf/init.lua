require('danielf.packer')
require('danielf.custom_remaps')
require('danielf.custom_vim_opts')

-- open help vertically
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help'},
  command = 'wincmd L'
})

P = function(v)
  print(vim.inspect(v))
  return v
end

DU = require("danielf.utils")
DK = require("danielf.keymap")
