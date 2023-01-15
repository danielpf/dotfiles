-- todo:
-- decent jumplist on statusline
-- decent buffer list on statusline
-- limit open buffers
-- connect these things with harpoon
-- link harpoon and nvim-tree marks
-- optional requires
-- set tmux window names (from vim)
-- tmux paste buffer
-- hop plugin
-- floating toggleterm
-- make terminal modifiable
-- telescope sg inside a dir in nvim

-- search directories for zoxide
-- add those with .git
-- ignore node_modules

require('danielf.packer')
require('danielf.custom_remaps')
require('danielf.custom_vim_opts')

-- open help vertically
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help'},
  command = 'wincmd L'
})


-- globals

P = function(v)
  print(vim.inspect(v))
  return v
end

DU = require("danielf.utils")
DC = require("danielf.collections")
DP = require("danielf.project")
DB = require('danielf.buffer_ring')
DK = require("danielf.keymap")
