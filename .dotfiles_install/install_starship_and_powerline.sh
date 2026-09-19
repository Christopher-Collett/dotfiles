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

# An earlier version of this script used GitHub's /blob/ HTML page as the
# download URL (`curl -O` also kept `%20` in the filename). Drop any HTML
# that was saved with a font extension so fontconfig does not trip over it.
shopt -s nullglob
for fontfile in "$FONT_DIR"/*.ttf "$FONT_DIR"/*.otf; do
    if file -b --mime-type "$fontfile" | grep -qi 'text/html'; then
        echo "Removing non-font file: $fontfile"
        rm -f "$fontfile"
    fi
done
shopt -u nullglob

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
