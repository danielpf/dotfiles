
cd $HOME
sudo apt-get install -y ninja-build gettext libtool libtool-bin \
  autoconf automake cmake g++ pkg-config unzip curl doxygen
git clone  https://github.com/neovim/neovim --depth 1

cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
