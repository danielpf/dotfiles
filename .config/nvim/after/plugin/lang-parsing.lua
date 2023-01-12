local k = require("danielf.keymap")

----- treesitter -----
require 'nvim-treesitter.configs'.setup {
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
}

----- tags -----

k.nnoremap('gd', DK.command("tjump"))

----- lsp -----
require('lspconfig.ui.windows').default_options.border = 'single'

DU.requireOpt("mason"):if_present(function(mason)
  mason.setup({
    providers = {
      "mason.providers.client",
      "mason.providers.registry-api" -- This is the default provider. You can still include it here if you want, as a fallback to the client provider.
    },
    -- log_level = vim.log.levels.DEBUG
  })
end)
require("mason.settings").set({
  ui = {
    border = 'rounded'
  }
})

local lsp = require('lsp-zero');
lsp.preset('lsp-compe')

lsp.set_preferences({
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    --error = '✘',
    --warn = '▲',
    --hint = '⚑',
    --info = 'i'
  }
})

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
  'emmet_ls',
  'rust_analyzer'
});

lsp.on_attach(function(client,bufnr)
  local function tell_you (f)
    -- TODO
    f()
    vim.notify()
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  k.nnoremap(DK.alt_n, vim.diagnostic.goto_next)
  k.nnoremap(DK.alt_p, vim.diagnostic.goto_prev)
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
end)

lsp.configure('emmet_ls', {
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'handlebars' },
})

-- Pass arguments to a language server
lsp.configure('tsserver', {
  on_attach = function(client, bufnr)
    -- local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- if string.match(bufname, '.+ember.+') then
    --   vim.lsp.buf_detach_client(bufnr, client.id)
    -- end
    -- on_attach(client, bufnr)
  end,
  settings = {
    completions = {
      completeFunctionCalls = true
    }
  }
})

lsp.nvim_workspace();
lsp.setup();

----- null_ls -----
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.diagnostics.eslint,
    },
})

----- cmp -----
local cmp = require('cmp');
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  sources = {{
    name = 'nvim_lsp',
    entry_filter = function(entry, _)
      return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
    end
  },
  { name = 'vsnip' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'buffer-lines', keyword_length = 4 },
  { name = 'rg', keyword_length = 3  },
  { name = 'npm', keyword_length = 4 },
  {
    { name = 'path' }
  }}
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
vim.cmd("hi IndentBlanklineContextStart guibg=#354566 gui=none")
vim.cmd("hi IndentBlanklineContextChar guifg=#9be0fd")
-- vim.cmd("hi IndentBlanklineContextChar guifg=#ffb86c")
-- for highlighting symbol: 865B13

----- treesj ---------------
local tsj = require('treesj')

local langs = { }

tsj.setup({
  -- Use default keymaps
  -- (<space>m - toggle, <space>j - join, <space>s - split)
  use_default_keymaps = true,

  -- Node with syntax error will not be formatted
  check_syntax_error = true,

  -- If line after join will be longer than max value,
  -- node will not be formatted
  max_join_length = 120,

  -- hold|start|end:
  -- hold - cursor follows the node/place on which it was called
  -- start - cursor jumps to the first symbol of the node being formatted
  -- end - cursor jumps to the last symbol of the node being formatted
  cursor_behavior = 'hold',

  -- Notify about possible problems or not
  notify = true,
  langs = langs,
})



