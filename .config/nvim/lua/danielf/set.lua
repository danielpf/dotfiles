
vim.opt.tabstop = 2;      -- number of spaces tab counts for
vim.opt.softtabstop = 2;  -- number of spaces tab counts for while editing
vim.opt.shiftwidth = 2;  -- number of spaces tab counts for while editing
vim.opt.expandtab = true; -- spaces inserted by vim (eg, autoident)
vim.opt.smartindent = true;

vim.opt.scrolloff = 4;

vim.opt.wrap = true;
vim.opt.colorcolumn = "120";

vim.opt.swapfile = false;
vim.opt.backup = false;
vim.opt.undodir = os.getenv("HOME") .. "/.undodir";

vim.opt.number = true;
vim.opt.relativenumber = true;

vim.opt.updatetime = 50;

vim.opt.incsearch = true;

vim.opt.termguicolors = true;


