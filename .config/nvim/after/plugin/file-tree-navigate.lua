------ buffers
-- check if buffer is in harpoo/ntree bookmarks
-- check if is modified
-- order by last write
-- order by number of modifications
-- order by last view
-- remove last


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
  sync_root_with_cwd = true,
  remove_keymaps = false, -- todo
  hijack_unnamed_buffer_when_opening = false,
  view = {
    adaptive_size = false,
    hide_root_folder = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "icon",
    highlight_modified = "name",
    full_name = true,
    indent_width = 2,
    icons = {
      git_placement = "before",
      modified_placement = "after",
      show = {
        git = false,
        modified = true,
      },
      glyphs = {
        modified = "*",
        git = {
          unstaged = "+",
          untracked = "?",
          deleted = "-",
        },
      },
    },
  },
  git = {
    ignore = false
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  actions = {
    change_dir = {
      restrict_above_cwd = true
    },
    expand_all = {
      exclude = { "node_modules", "dist", "build" }
    },
    open_file = {
      resize_window = false
    },
  },
  modified = {
    enable = true
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = false,
    debounce_delay = 500,
    severity = {
      min = vim.diagnostic.severity.ERROR,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  on_attach = function (bufnr)
    local api = require("nvim-tree.api")

    local opts = {
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }

    k.nnoremap(k.c_e, k.c_e, opts)
    k.nnoremap("H", "23k", opts)
    k.nnoremap("L", "23j", opts)

    k.nnoremap('z', function()
      local node = api.tree.get_node_under_cursor()
      if node.type == "directory" then
        api.node.open.edit()
      else
        api.node.navigate.parent_close()
      end
    end, opts)

    k.nnoremap('Z', function()
      api.node.navigate.parent_close()
    end, opts)
  end
})

k.nnoremap(k.alt_e, k.command("NvimTreeToggle"))
k.nnoremap(k.c_g, k.command("NvimTreeFindFile"))

vim.cmd("hi NvimTreeGitDirty guifg=#8be9fd")
vim.cmd("hi NvimTreeGitUnstaged guifg=#ff6e6e")
vim.cmd("hi clear NvimTreeOpenedFile")
vim.cmd("hi NvimTreeOpenedFile gui=underline")

