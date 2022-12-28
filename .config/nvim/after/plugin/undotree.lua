vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.undodir";
vim.g['undotree_WindowLayout'] = 3;
vim.g['undotree_HighlightChangedText'] = 0;

local km = require("danielf.keymap")

local undoTreeGroup = vim.api.nvim_create_augroup('undoTreeGroup', {clear = true})

--local windows = vim.fn.getwininfo();
--vim.api.nvim_create_autocmd('BufWritePost', {
--    command = 'UndotreeShow', group = undoTreeGroup
--})
--
-- todo: write your own netrw?
--vim.api.nvim_create_autocmd('BufLeave', {
  --  command = 'UndotreeHide', group = undoTreeGroup
  --})

