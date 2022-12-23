local km = require("danielf.keymap");

vim.g.mapleader = " ";
km.nnoremap(km.f_leader("pv"), "<cmd>Ex<CR>");

km.vnoremap("J", ":m '>+1<CR>gv=gv");
km.vnoremap("K", ":m '>-2<CR>gv=gv");

km.nnoremap("J", "mzJ`z");

km.nnoremap("n", "nzzzv");
km.nnoremap("N", "Nzzzv");

km.xnoremap(km.f_leader("p"), "\"_dP");
km.nnoremap(km.f_leader("d"), "\"_d");
km.vnoremap(km.f_leader("d"), "\"_d");

km.nnoremap("<leader><leader>", ":");

km.tnoremap(km.k_esc, km.k_c_leftbar .. km.k_c_n);

