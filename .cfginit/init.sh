git clone --bare https://github.com/danielpf/dotfiles.git .cfg
git --git-dir=.cfg/ --work-tree=$HOME checkout

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
