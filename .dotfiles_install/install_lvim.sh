#!/bin/bash
set -euo pipefail

echo "Starting LunarVim installation for Ubuntu..."

sudo apt-get update
sudo apt-get install -y curl git build-essential neovim nodejs npm python3-pip unzip

# Use a user prefix for this script only. Do not write `prefix` to ~/.npmrc —
# that setting is incompatible with nvm.
mkdir -p "${HOME}/.npm-global/lib"
export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
export PATH="${HOME}/.npm-global/bin:${HOME}/.cargo/bin:${HOME}/.local/bin:${PATH}"

if ! command -v rustc >/dev/null 2>&1; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck disable=SC1091
if [ -f "${HOME}/.cargo/env" ]; then
    . "${HOME}/.cargo/env"
fi

echo "Installing lazygit..."
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
LAZYGIT_VERSION="$(curl -sS "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')"
curl -fLo "${tmpdir}/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf "${tmpdir}/lazygit.tar.gz" -C "$tmpdir" lazygit
sudo install "${tmpdir}/lazygit" -D -t /usr/local/bin/

echo "Ensuring everything is installed properly..."
git --version
make --version
python3 --version
node --version
npm --version
rustc --version
cargo --version
lazygit --version

echo "Installing LunarVim package dependencies..."
npm install -g neovim tree-sitter-cli
python3 -m pip install --user --break-system-packages pynvim
command -v rg >/dev/null 2>&1 || cargo install ripgrep
command -v fd >/dev/null 2>&1 || cargo install fd-find

# Install LunarVim. config.lua is tracked in this repo; do not overwrite it.
echo "Installing LunarVim..."
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -sS https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies

lvim --version
echo "Run 'lvim' to start LunarVim."
