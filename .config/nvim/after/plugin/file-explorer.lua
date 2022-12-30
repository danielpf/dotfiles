------ netrw
--vim.g['netrw_banner'] = 0;
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

local k = require("danielf.keymap")

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
    highlight_git = true,
    highlight_opened_files = "name",
    indent_width = 2,
    icons = {
      show = {
        git = true
      },
      glyphs = {
        git = {
          unstaged = "m",
          untracked = "u",
          deleted = "d",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  on_attach = function (bufnr)
    local api = require("nvim-tree.api")

    local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
    k.nnoremap(k.c_e, k.c_e, opts)
    k.nnoremap(k.c_l, function() print(api.tree.get_node_under_cursor().absolute_path) end, opts)
  end
})

local api = require("nvim-tree.api")
k.nnoremap(k.alt_e, k.command("NvimTreeToggle"))
k.nnoremap(k.c_g, k.command("NvimTreeFindFile"))


