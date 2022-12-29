------ netrw

----vim.g['netrw_banner'] = 0;

--vim.g['netrw_liststyle'] = 3;
--vim.g['netrw_browse_split'] = 4;
--vim.g['netrw_winsize'] = 80; -- split width = 25%

vim.g['netrw_preview']   = 1
vim.g['netrw_liststyle'] = 3
vim.g['netrw_winsize']   = 30

------ nvim-tree

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

k = require("danielf.keymap")
k.nnoremap(k.lead.."e", ":NvimTreeToggle<CR>")
