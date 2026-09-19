#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y terminator

mkdir -p "${HOME}/.config/terminator"

if [ ! -f "${HOME}/.config/terminator/background.jpg" ]; then
    cp "${HOME}/.config/terminator/example.background.jpg" \
        "${HOME}/.config/terminator/background.jpg"
fi

if [ ! -f "${HOME}/.config/terminator/config" ]; then
    cp "${HOME}/.config/terminator/example.config" \
        "${HOME}/.config/terminator/config"
    sed -i "s|HOME_DIR|${HOME}|g" "${HOME}/.config/terminator/config"
else
    echo "Terminator config already exists; not overwriting."
    echo "Expected font: RobotoMono Nerd Font Light 11"
fi
