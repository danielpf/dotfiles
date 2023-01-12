-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd("packadd packer.nvim")
end

-- run packer; do ":so %" and then ":PackerSync"
require('packer').startup(function(use)
  use('wbthomason/packer.nvim'); -- Packer can manage itself

  use('nvim-lua/plenary.nvim'); -- useful library for plugins

  use('theprimeagen/harpoon');
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-telescope/telescope-live-grep-args.nvim'},
    },
    config = function()
      require('telescope').load_extension('live_grep_args')
    end
  };
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use 'famiu/bufdelete.nvim'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'lewis6991/gitsigns.nvim'
  use 'airblade/vim-rooter'
  use 'mbbill/undotree'
  use "windwp/nvim-autopairs"
  use "phaazon/hop.nvim"
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })
  use "lukas-reineke/indent-blankline.nvim"
  use "Wansmer/treesj" -- join lines

  use('akinsho/toggleterm.nvim')

  use('nvim-treesitter/nvim-treesitter', { run = ":TSUpdate" });
  use('nvim-treesitter/playground');
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      -- Autocompletion sources
      {'hrsh7th/cmp-buffer'},  -- get from current buffer
      {"amarakon/nvim-cmp-buffer-lines"},  -- get from current buffer
      {'hrsh7th/cmp-path'},  -- file paths
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},
      {'hrsh7th/cmp-nvim-lsp-signature-help'},  -- nvim function signatures
      {'hrsh7th/vim-vsnip'},
      {"lukas-reineke/cmp-rg"},
      {"David-Kunz/cmp-npm"},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }
  use "jose-elias-alvarez/null-ls.nvim"

  -- visuals
  use('Mofiqul/dracula.nvim')
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    tag = 'v1.1.0'
  });
  use('blueyed/vim-diminactive'); -- man pages with vim
  use('nvim-lualine/lualine.nvim') -- Fancier statusline
  use("rcarriga/nvim-notify")

  use('paretje/vim-man'); -- man pages with vim

  -- customs
  use('/home/jdoe/scripts/nvim/stackmap/');
  use('/home/jdoe/scripts/nvim/ember-custom/');

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand 'packer.lua',
})
--]]

