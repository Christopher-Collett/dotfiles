#!/bin/bash
# Bootstrap a new Ubuntu machine after checking out this bare repo.
# See README.md for the git clone / checkout steps.
set -euo pipefail

cd "$(dirname "$0")"

echo "Installing common packages..."
sudo apt-get update
sudo apt-get install -y curl git tmux xclip python3-pip fontconfig xz-utils file

./install_starship_and_powerline.sh
./install_terminator.sh

if [ ! -f "${HOME}/.dotfiles_local_settings" ]; then
    cp "${HOME}/.dotfiles_local_settings.example" "${HOME}/.dotfiles_local_settings"
    echo "Created ~/.dotfiles_local_settings from the example (not tracked)."
fi

echo
echo "Core setup is done. Restart the terminal (or log out) so the Nerd Font is used."
echo "Optional: install LunarVim with  $(pwd)/install_lvim.sh"
