local nnoremap = require("danielf.keymap").nnoremap;

nnoremap("<leader>gs", function() vim.cmd("Git") end);
nnoremap("<leader>gb", function() vim.cmd("Git blame") end);
