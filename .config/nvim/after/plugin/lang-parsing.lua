require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
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

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  --ignore_install = { "javascript" },

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

-----

local lsp = require('lsp-zero');

lsp.preset('recommended');

lsp.ensure_installed({
        'tsserver',
        'eslint',
        'sumneko_lua',
        'rust_analyzer'
});

lsp.nvim_workspace();

--lsp.set_preferences({
--  sign_icons = { }
--});

lsp.setup();

------

require("nvim-autopairs").setup {
  disable_filetype = { "TelescopePrompt" , "vim" },
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
