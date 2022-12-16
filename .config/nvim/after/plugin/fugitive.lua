local nnoremap = require("danielf.keymap").nnoremap;

nnoremap("<leader>gs", function() vim.cmd("Git") end);
