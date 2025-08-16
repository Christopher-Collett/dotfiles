#!/bin/bash
set -e # ensure script terminates on failures

echo "Starting LunarVim installation for Ubuntu..."

sudo apt update
sudo apt install -y curl git build-essential neovim nodejs cargo

echo "Configuring npm to avoid EACCESS issues..."
mkdir -p ~/.npm-global/lib
npm config set prefix '~/.npm-global'

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

source ~/.bashrc # update path

echo "Ensuring everything is installed properly..."
git --version
make --version
python --version
nodejs --version
npm --version
rustc --version
cargo --version
lazygit --version

echo "Installing LunarVim package dependencies..."
npm install -g neovim tree-sitter-cli
pip install --break-system-packages pynvim
cargo install ripgrep fd-find

# Install LunarVim
echo "Installing LunarVim..."
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies

cp $HOME/.config/lvim/example.config.lua $HOME/.config/lvim/config.lua

lvim --version
echo "Run 'lvim' to start LunarVim."
