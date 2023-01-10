NVIM_INSTALL_OPTION="compile"

cd $HOME

mv $HOME/.bashrc $HOME/.bashrc.old
git clone --bare https://github.com/danielpf/dotfiles.git .cfg
git --git-dir=.cfg/ --work-tree=$HOME checkout

mkdir -f $HOME/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting --depth 1 &
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions --depth 1 &

sudo apt-get install -y inetutils-ping ripgrep zoxide htop
zoxide init zsh > $HOME/.zoxide.sh
find -maxdepth 2 -not -path '*/.*' -type d | xargs -n 1 zoxide add

if [ $NVIM_INSTALL_OPTION = "compile" ]; then
  bash $HOME/scripts/compile_nvim.sh
else
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
  tar xzf /tmp/nvim.tar.gz
fi

. $HOME/.common.sh
tmux

