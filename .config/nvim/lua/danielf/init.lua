require('danielf.packer')
require('danielf.custom_remaps')
require('danielf.custom_vim_opts')

-- todo:
-- decent jumplist on statusline
-- decent buffer list on statusline
-- limit open buffers
-- connect these things with harpoon
-- link harpoon and nvim-tree marks
-- optional requires
-- set tmux window names (from vim)

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
