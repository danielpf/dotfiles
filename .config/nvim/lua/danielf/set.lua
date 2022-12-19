
vim.opt.tabstop = 2;      -- number of spaces tab counts for
vim.opt.softtabstop = 2;  -- number of spaces tab counts for while editing
vim.opt.shiftwidth = 2;  -- number of spaces tab counts for while editing
vim.opt.expandtab = true; -- spaces inserted by vim (eg, autoident)
vim.opt.smartindent = true;

vim.opt.number = true;
vim.opt.relativenumber = true;

vim.opt.joinspaces = false;
vim.opt.wrap = true;
vim.opt.colorcolumn = "120";

vim.opt.incsearch = true;
vim.opt.scrolloff = 4;
vim.opt.splitbelow = true;

vim.opt.swapfile = false;
vim.opt.backup = false;
vim.opt.undodir = os.getenv("HOME") .. "/.undodir";

vim.opt.updatetime = 50;

vim.opt.termguicolors = true;

vim.opt.list = true;
--vim.opt.listchars = ..

vim.g['netrw_liststyle'] = 3;
--vim.g['netrw_banner'] = 0;
vim.g['netrw_browse_split'] = 3;
vim.g['netrw_winsize'] = 25; -- split width = 25%

