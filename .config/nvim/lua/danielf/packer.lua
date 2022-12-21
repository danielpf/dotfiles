-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end


vim.cmd([[packadd packer.nvim]]);

-- run packer
-- Do ":so %" and then ":PackerSync"
require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim');

  use('theprimeagen/harpoon');
  use('nvim-lua/plenary.nvim');
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-telescope/telescope-live-grep-args.nvim'},
    },
    config = function() require('telescope').load_extension('live_grep_args') end
  };

  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
	  vim.cmd('colorscheme rose-pine')
	  end,
	  tag = 'v1.1.0'
  });

  use('nvim-treesitter/nvim-treesitter', { run = ":TSUpdate" });
  use('nvim-treesitter/playground');

  use('mbbill/undotree');

  use('tpope/vim-fugitive');
  use('lewis6991/gitsigns.nvim');
  use('airblade/vim-rooter');

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use('nvim-lualine/lualine.nvim') -- Fancier statusline

  use('paretje/vim-man');

  use('/home/jdoe/data/stackmap/');

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

