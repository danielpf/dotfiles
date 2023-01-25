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

-- globals

P = function(v)
  print(vim.inspect(v))
  return v
end

DU = require("danielf.utils")
DC = require("danielf.collections")
DP = require("danielf.path")
DB = require('danielf.buffer_ring')
DK = require("danielf.keymap")

----------

-- open help vertically
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help'},
  command = 'wincmd L'
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(ev)
    if DU.is_editor(ev.buf) then
      require("plenary.job"):new({
        command = "tmux",
        args={
          "rename-window",
          "nvim:"..DP.with_tilda(vim.api.nvim_buf_get_name(ev.buf))
        }
      }):sync()
    end
  end
})

vim.api.nvim_create_autocmd('VimLeave', {
  callback = function(ev)
    require("plenary.job"):new({
      command = "tmux",
      args={
        "rename-window",
        "#{active_window_index}"
      }
    }):sync()
  end
})
