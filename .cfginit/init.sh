
cd $HOME
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz

mkdir -f ~/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting --depth 1 &
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions --depth 1 &

mv ~/.bashrc ~/.bashrc.old
git clone --bare https://github.com/danielpf/dotfiles.git .cfg
git --git-dir=.cfg/ --work-tree=$HOME checkout

sudo apt-get install -y ripgrep zoxide
zoxide init zsh > $HOME/.zoxide.sh
