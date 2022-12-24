local km = require("danielf.keymap");
local k = km.k
local nnoremap = km.nnoremap;

local builtin = require('telescope.builtin');

nnoremap('<tab><tab>', builtin.pickers);
nnoremap(k.lead..'<tab>', builtin.resume);
nnoremap(k.c_f, builtin.current_buffer_fuzzy_find);
nnoremap(k.lead..'ta', builtin.builtin);
nnoremap(k.lead..'tb', builtin.buffers);
nnoremap(k.lead..'th', builtin.search_history);
nnoremap(k.lead..'to', builtin.oldfiles);
nnoremap(k.lead..'tc', builtin.command_history);
nnoremap(k.lead..'tv', function() builtin.find_files({hidden=true, cwd='~/.config/nvim'}) end);
nnoremap(k.lead..'tg', function() require('telescope').extensions.live_grep_args.live_grep_args(); end);

nnoremap(k.lead..'tf', function() builtin.find_files({hidden=true}) end);
nnoremap('<C-p>', function() builtin.find_files({hidden=true}) end);

nnoremap(k.lead..'gf', builtin.git_files);

nnoremap('<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")});
end);

