local k = require("danielf.keymap");

k.nnoremap("<s-q>",":q<cr>");
k.nnoremap("<s-w>",":w<cr>");
k.nnoremap("+",":noh"..k.enter);
