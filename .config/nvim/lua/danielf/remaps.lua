local k = require("danielf.keymap");

vim.g.mapleader = " ";

k.inoremap(k.esc, k.c_c); -- to get out of dialogs; doesnt seem to work
k.nnoremap(k.lead.."pv", "<cmd>Ex<CR>"); -- netrw

-- move selection in visual mode
k.vnoremap("J", ":m '>+1<CR>gv=gv");
k.vnoremap("K", ":m '<-2<CR>gv=gv");
k.vnoremap("H", "");
k.vnoremap("L", "");

k.nnoremap(k.c_a, "_");
k.nnoremap(k.c_j, "*");

k.nnoremap("J", "mzJ`z"); -- join line
k.nnoremap("J", "mzJ`z");

k.nnoremap(k.c_d, k.c_d.."zz") -- keep cursor centered while scrolling
k.nnoremap(k.c_u, k.c_u.."zz")

k.nnoremap("n", "nzzzv"); -- keep cursor centered while searching
k.nnoremap("N", "Nzzzv");

-- pasting
k.xnoremap(k.lead.."p", "\"_dP");
k.nnoremap(k.lead.."d", "\"_d");
k.vnoremap(k.lead.."d", "\"_d");

k.nnoremap(k.lead..k.lead, ":");

-- window
k.nnoremap(k.up,     ":vert resize +5"..k.enter);
k.nnoremap(k.down,   ":vert resize -5"..k.enter);
k.nnoremap(k.s_up,   ":resize +5"..k.enter);
k.nnoremap(k.s_down, ":resize -5"..k.enter);

-- bottom command line navigation
k.cnoremap("<C-f>", "<Right>");
k.cnoremap("<C-b>", "<Left>");
k.cnoremap("<C-a>", "<Home>");
k.cnoremap("<M-b>", "<C-Left>");
k.cnoremap("<M-f>", "<C-Right>");




