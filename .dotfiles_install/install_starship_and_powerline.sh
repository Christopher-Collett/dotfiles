#!/bin/bash
# Install Starship, Powerline (tmux statusline), and RobotoMono Nerd Font.
#
# Nerd Fonts include Powerline glyphs ( ) plus the extra icons Starship uses
# (e.g. ). The Debian `fonts-powerline` package is only a symbols fallback
# font — it is not a patched Roboto Mono and is not sufficient here.
set -euo pipefail

sudo apt-get update
sudo apt-get install -y curl python3-pip fontconfig xz-utils file

FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "$FONT_DIR"

if ! fc-list "RobotoMono Nerd Font" | grep -q .; then
    echo "Installing RobotoMono Nerd Font..."
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    archive="${tmpdir}/RobotoMono.tar.xz"
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.tar.xz" \
        -o "$archive"
    tar -xJf "$archive" -C "$tmpdir"
    find "$tmpdir" -type f \( -name '*.ttf' -o -name '*.otf' \) \
        -exec cp -f {} "$FONT_DIR/" \;
else
    echo "RobotoMono Nerd Font already present."
fi

# User fonts do not need sudo; cache just this directory.
fc-cache -fv "$FONT_DIR"

if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed."
fi

python3 -m pip install --user --break-system-packages powerline-status

if [ -d "${HOME}/.local/bin" ]; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

echo
echo "Fonts + Starship + Powerline installed."
echo "Point your terminal at: RobotoMono Nerd Font Light 11"
echo "Then restart the terminal so the new font is picked up."
