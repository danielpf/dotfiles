git clone --bare https://github.com/danielpf/dotfiles.git .cfg
git --git-dir=.cfg/ --work-tree=$HOME checkout

sudo apt-get install ripgrep
