local keymap = require("danielf.keymap");

local nnoremap = keymap.nnoremap;

vim.g.mapleader = " ";
nnoremap("<leader>pv", "<cmd>Ex<CR>");

