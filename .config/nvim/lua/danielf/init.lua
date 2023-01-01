require('danielf.packer');
require('danielf.remaps');
require('danielf.set_opts');

-- open help vertically
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help'},
  command = 'wincmd L'
})

P = function(v)
  print(vim.inspect(v))
  return v
end

