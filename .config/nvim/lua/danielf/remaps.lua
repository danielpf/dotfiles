local km = require("danielf.keymap");
local k = km.k

vim.g.mapleader = " ";

km.inoremap(k.c_c, k.esc); -- to get out of dialogs
km.nnoremap(k.lead.."pv", "<cmd>Ex<CR>"); -- netrw

km.nnoremap(k.lead.."pv", "<cmd>Ex<CR>"); -- netrw

-- move selection in visual mode
km.vnoremap("J", ":m '>+1<CR>gv=gv");
km.vnoremap("K", ":m '<-2<CR>gv=gv");

km.nnoremap("J", "mzJ`z"); -- join line
km.nnoremap("J", "mzJ`z");

km.nnoremap(k.c_d, k.c_d.."zz") -- keep cursor centered while scrolling
km.nnoremap(k.c_u, k.c_u.."zz")

km.nnoremap("n", "nzzzv"); -- keep cursor centered while searching
km.nnoremap("N", "Nzzzv");

-- pasting
km.xnoremap(k.lead.."p", "\"_dP");
km.nnoremap(k.lead.."d", "\"_d");
km.vnoremap(k.lead.."d", "\"_d");

km.nnoremap(k.lead..k.lead, ":");


