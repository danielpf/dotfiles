local keymap = require("danielf.keymap");


vim.g.mapleader = " ";
keymap.nnoremap("<leader>pv", "<cmd>Ex<CR>");

keymap.vnoremap("J", ":m '>+1<CR>gv=gv");
keymap.vnoremap("K", ":m '>-2<CR>gv=gv");

keymap.nnoremap("J", "mzJ`z");

keymap.nnoremap("n", "nzzzv");
keymap.nnoremap("N", "Nzzzv");

keymap.xnoremap("<leader>p", "\"_dP");
keymap.nnoremap("<leader>d", "\"_d");
keymap.vnoremap("<leader>d", "\"_d");

keymap.nnoremap("<leader><leader>", ":");
