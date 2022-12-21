local nnoremap = require("danielf.keymap").nnoremap;

local builtin = require('telescope.builtin');
nnoremap('<leader>pf', builtin.find_files);
nnoremap('<C-p>', builtin.git_files);
nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);
nnoremap('<leader>pg', function()
  require('telescope').extensions.live_grep_args.live_grep_args();
end);
