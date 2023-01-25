local k = require("danielf.keymap")

----- treesitter -----
require 'nvim-treesitter.configs'.setup({
  ensure_installed = {
    "markdown",
    "glimmer",
    "help",
    "javascript",
    "typescript",
    "c",
    "lua",
    "rust"
  },
  sync_install = false, -- only applied to `ensure_installed`
  auto_install = true, -- install missing parsers when entering buffer

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    --disable = function(lang, buf)
      --    local max_filesize = 100 * 1024 -- 100 KB
      --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      --    if ok and stats and stats.size > max_filesize then
      --        return true
      --    end
      --end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
})

----- tags -----

k.nnoremap('gd', DK.command("tag"))

----- lsp -----
require('lspconfig.ui.windows').default_options.border = 'single'

require("mason").setup({
  providers = {
    "mason.providers.client",
    "mason.providers.registry-api" -- This is the default provider. You can still include it here if you want, as a fallback to the client provider.
  }, -- log_level = vim.log.levels.DEBUG
})
require("mason.settings").set({
  ui = {
    border = 'rounded'
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'eslint',
    'jsonls',
    'emmet_ls',
    'sumneko_lua',
    'rust_analyzer',
  }
})


local lspconfig = require('lspconfig')
local get_servers = require('mason-lspconfig').get_installed_servers
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, server_name in ipairs(get_servers()) do
  local lsp_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    require("lsp_signature").on_attach({
      bind = true,
      shadow_guibg = 'Green'
    }, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    k.nnoremap(DK.alt_n, vim.diagnostic.goto_next, bufopts)
    k.nnoremap(DK.alt_p, vim.diagnostic.goto_prev, bufopts)
    k.nnoremap('gl', vim.diagnostic.open_float, bufopts)

    k.nnoremap('gd', vim.lsp.buf.definition, bufopts)
    k.nnoremap('gD', vim.lsp.buf.declaration, bufopts)
    k.nnoremap('gi', vim.lsp.buf.implementation, bufopts)
    k.nnoremap('gr', vim.lsp.buf.references, bufopts)
    k.nnoremap('gT', vim.lsp.buf.type_definition, bufopts)
    k.nnoremap('ga', function() vim.lsp.buf.code_action() end)
    k.nnoremap('K', vim.lsp.buf.hover, bufopts)
    k.nnoremap(DK.c_k, vim.lsp.buf.signature_help, bufopts)

    k.nnoremap(DK.lead..'wa', vim.lsp.buf.add_workspace_folder, bufopts)
    k.nnoremap(DK.lead..'wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    k.nnoremap(DK.lead..'wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)

    local g_diag_id = vim.api.nvim_create_augroup("diag_hover", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = g_diag_id,
      buffer = bufnr,
      callback = function()
        if not vim.b.my_hover_pos then vim.b.my_hover_pos = { nil, nil } end

        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local pos_changed = cursor_pos[1] ~= vim.b.my_hover_pos[1] or cursor_pos[2] ~= vim.b.my_hover_pos[2]
        if pos_changed then
          if #vim.diagnostic.get() > 0 then
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always", -- show source in diagnostic popup window
              prefix = " ",
            })
          end
        end

        vim.b.my_hover_pos = cursor_pos
      end,
    })

    if client.server_capabilities.documentHighlightProvider then
      local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold" , {
        group = gid,
        buffer = bufnr,
        callback = function ()
          vim.lsp.buf.document_highlight()
        end
      })

      vim.api.nvim_create_autocmd("CursorMoved" , {
        group = gid,
        buffer = bufnr,
        callback = function ()
          vim.lsp.buf.clear_references()
        end
      })
    end

    if vim.g.logging_level == "debug" then
      local msg = string.format("Language server %s started!", client.name)
      vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
    end
  end -- end of on_attach

  local cfg = {
    on_attach = function (client,bufnr)
      lsp_attach(client,bufnr)
    end,
    capabilities = lsp_capabilities,
  }

  if server_name == 'sumneko_lua' then
    cfg.filetypes = {
      'lua'
    }
    cfg.settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = {'vim'}
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {vim.api.nvim_get_runtime_file("", true)},
          -- library = {
            --   vim.fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
            --   vim.fn.stdpath("config"),
            -- }
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        }
      }
  elseif server_name == 'rust_analyzer' then
    cfg.settings = {
      ["rust-analyzer"] = {
        granularity = {
          group = "module"
        },
        prefix = "self"
      }
    }
  elseif server_name == 'emmet_ls' then
    cfg.init_options = {
      runtimepath = vim.o.runtimepath
    }
  elseif server_name == 'emmet_ls' then
      cfg.filetypes = { "hbs", "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby" }
   end
   lspconfig[server_name].setup(cfg)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

----- null_ls -----
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.eslint,
  },
})

-------- cmp -----

require("cmp-npm").setup()

local cmp = require('cmp');
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = function()
      if not cmp.visible() then
        cmp.complete()
      else
        cmp.select_next_item()
      end
    end,
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<cr>'] = cmp.mapping.confirm({ select = true, }),
  }),
  sources = {
    {
      name = 'nvim_lsp',
      entry_filter = function(entry, _)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end
    },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    -- { name = 'rg', keyword_length = 3  },
    { name = 'npm', keyword_length = 4 },
    { name = 'path', keyword_length = 3  }
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {
      name = "buffer",
      max_item_count = 3,
      option = { keyword_pattern = [[\k\+]] }
    },
    { name = "buffer-lines", max_item_count = 3  }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline'}
  })
})

----- diagnostic -----
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

local orig_signs_handler = vim.diagnostic.handlers.signs
local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
local orig_underline_handler = vim.diagnostic.handlers.underline

local diagnostic_namespace_hidden = vim.api.nvim_create_namespace("my_hidden")

vim.diagnostic.handlers.virtual_text = {
  show = function(namespace, bufnr, diagnostics, opts)
    local diagnostic_regex_hide_list = {
      'File is a CommonJS module.*',
      '\'$\' is declared but.*'
    }
    local filtered_diagnostics = vim.tbl_filter(function (d)
      for _,pat in pairs(diagnostic_regex_hide_list) do
        if string.match(d.message, pat) then
          return false
        end
      end
      return true
    end, diagnostics)
    orig_virtual_text_handler.show(namespace, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(ns, bufnr)
    -- how to use?
    orig_virtual_text_handler.hide(ns, bufnr)
  end,
}

----- telescope -----

k.nnoremap(k.lead.."le", function() vim.cmd("Telescope diagnostics") end)

local builtin = require('telescope.builtin');
k.nnoremap(k.lead..'lr', builtin.lsp_references);
k.nnoremap(k.lead..'li', builtin.lsp_implementations);
k.nnoremap(k.lead..'ld', builtin.lsp_definitions);
k.nnoremap(k.lead..'lt', builtin.lsp_type_definitions);
k.nnoremap(k.lead..'lc', builtin.lsp_incoming_calls);
k.nnoremap(k.lead..'lo', builtin.lsp_outgoing_calls);
k.nnoremap(k.lead..'ll', builtin.lsp_document_symbols);

----- autopairs -----
require("nvim-autopairs").setup {
  disable_filetype = { "TelescopePrompt", "vim" },
  map_c_h = true,
  map_c_w = true,
}
--local disable_in_macro = false  -- disable when recording or executing a macro
--local disable_in_visualblock = false -- disable when insert after visual block mode
--local disable_in_replace_mode = true
--local ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=]
--local enable_moveright = true
--local enable_afterquote = true  -- add bracket pairs after quote
--local enable_check_bracket_line = true  --- check bracket in same line
--local enable_bracket_in_quote = true --
--local enable_abbr = false -- trigger abbreviation
--local break_undo = true -- switch for basic rule break undo sequence
--local check_ts = false
--local map_cr = true
--local map_bs = true  -- map the <BS> key
--local map_c_h = false  -- Map the <C-h> key to delete a pair
--local map_c_w = false -- map <c-w> to delete a pair if possible

----- indent-blankline -----
require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = true,
  show_current_context_start = true,
}
vim.cmd("hi IndentBlanklineContextStart gui=none")
-- vim.cmd("hi IndentBlanklineContextStart guibg=#21232e gui=none")
-- vim.cmd("hi IndentBlanklineContextChar guifg=#21232e")
vim.cmd("hi IndentBlanklineContextChar guifg=#6272a4")
-- for highlighting symbol: 865B13

----- treesj ---------------
local tsj = require('treesj')
-- plugin for splitting/unsplitting lines

local langs = { }

tsj.setup({
  -- Use default keymaps
  -- (<space>m - toggle, <space>j - join, <space>s - split)
  use_default_keymaps = false,

  check_syntax_error = true,  -- Node with syntax error will not be formatted

  -- If line after join will be longer than max value, node will not be formatted
  max_join_length = 120,

  -- hold|start|end:
  -- hold - cursor follows the node/place on which it was called
  -- start - cursor jumps to the first symbol of the node being formatted
  -- end - cursor jumps to the last symbol of the node being formatted
  cursor_behavior = 'hold',

  notify = true,  -- Notify about possible problems or not
  langs = langs,
})
k.nnoremap(k.lead..'j', DK.command("TSJToggle"));



