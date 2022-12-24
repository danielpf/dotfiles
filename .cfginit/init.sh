git clone --bare https://github.com/danielpf/dotfiles.git .cfg
git --git-dir=.cfg/ --work-tree=$HOME checkout

#wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

sudo apt-get install ripgrep zoxide
zoxide init zsh > $HOME/.zoxide.sh
