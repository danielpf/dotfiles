vim.cmd([[packadd packer.nvim]]);

-- Do ":so %" and then ":PackerSync"
return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim');

  use('theprimeagen/harpoon');
  use('nvim-lua/plenary.nvim');
  use('nvim-telescope/telescope.nvim');
end)
